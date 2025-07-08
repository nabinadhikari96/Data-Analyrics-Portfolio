USE advancedonlinefood
SELECT * FROM uae_online_food_orders

/*Question 1: Start with RFM Segmentation (SQL)
Goal: Assign each customer:
Recency: Days since last order
Frequency: Number of total orders
Monetary: Total amount spent*/
SELECT `Customer ID`,
DATEDIFF(CURRENT_DATE(),MAX(`Order Time`)) as Recency,
COUNT(`Order ID`),
SUM(`Price`*`Quantity`) as Spend_Money
FROM uae_online_food_orders
GROUP BY `Customer ID`
ORDER BY Spend_Money DESC;

/*Question 2. What is the average number of days between each customer's orders?
This helps us understand:
How frequently a customer re-orders
Who’s likely to churn (long gaps between orders)
Who’s a loyal or frequent buyer*/

WITH rank_orders AS(
SELECT `Customer ID`,
`Order Time`,
ROW_NUMBER() OVER(PARTITION BY `Customer ID` ORDER BY `Order Time`) as orders_rank
FROM uae_online_food_orders
),
order_pairs AS(
SELECT curr.`Customer ID`,
curr.`Order Time` as curr_orders,
next.`Order Time` as next_orders,
DATEDIFF(next.`Order Time`,curr.`Order Time`) as Gap
FROM 
rank_orders curr 
JOIN
rank_orders next
ON
curr.`Customer ID` = next.`Customer ID`
AND curr.orders_rank = next.orders_rank-1
)
SELECT `Customer ID`,
ROUND(AVG(Gap),2) as avg_gap,
COUNT(*) as gap_days
FROM order_pairs
GROUP BY `Customer ID`
ORDER BY avg_gap;

/*3: Simulate Discounts & Measure Revenue Loss
"If we apply a 10% discount on orders where total order value > 100 AED, how much revenue is lost? 
What is the total discounted revenue?".*/
SELECT
SUM(`Price`*`Quantity`) as Total_Revenue,
SUM(CASE WHEN (`Price`*`Quantity`)>100 THEN (`Price`*`Quantity`)*0.9 ELSE (`Price`*`Quantity`) END) AS amount_after_disc,
SUM(CASE WHEN (`Price`*`Quantity`)>100 THEN (`Price`*`Quantity`)*0.1 ELSE 0 END) AS amount_loss
FROM uae_online_food_orders;

/*Question 4: Who Are Our Top Spending Customers?
“Identify the top 10 customers who have spent the most money overall on the platform.”*/
SELECT `Customer ID`,
SUM(`Price`*`Quantity`) as Total_Spend
From
uae_online_food_orders
GROUP BY `Customer ID`
ORDER BY Total_Spend DESC
LIMIT 10

/*Question 6: Product Basket Analysis (Item Pairs)
"Which food items are most frequently bought together in a single order?"*/
SELECT T1.`Item Name` as item1,T2.`Item Name` as item2,
COUNT(*) as combo_count
FROM uae_online_food_orders as T1
JOIN
uae_online_food_orders as T2
ON T1.`Order ID`= T2.`Order ID`
AND T1.`Item Name` < T2.`Item Name`
GROUP BY item1 , item2
ORDER BY combo_count DESC
LIMIT 10;

/*Segment customers based on their total spending into three categories:
High Spenders: Spend > 1000 AED
Medium Spenders: 500–1000 AED
Low Spenders: < 500 AED*/
SELECT 
    `Customer ID`,
    SUM(`Quantity` * `Price`) AS Total_Spending,
    CASE
        WHEN SUM(`Quantity` * `Price`) > 1000 THEN 'High Spenders'
        WHEN SUM(`Quantity` * `Price`) BETWEEN 500 AND 1000 THEN 'Medium Spenders'
        ELSE 'Low Spenders'
    END AS Spending_Catergory
FROM
    uae_online_food_orders
GROUP BY `Customer ID`
ORDER BY SUM(`Quantity` * `Price`) DESC;


/* Question 8:
Create an RFM Score for each customer using:
Metric   	Meaning	                   How to Calculate
Recency	    Days since last order	   DATEDIFF(Current_Date, MAX(Order Time))
Frequency	Number of orders placed	    COUNT(Order ID)
Monetary	Total amount spent	        SUM(Price * Quantity)*?

Then assign scores (1–3) to each metric and compute the final RFM score by concatenating the three.*/

WITH rfm AS (
SELECT `Customer ID`,
DATEDIFF(CURRENT_DATE(),MAX(`Order Time`)) as recency,
COUNT(*) as num_of_orders,
SUM(`Quantity`*`Price`) as spend_money
FROM uae_online_food_orders
GROUP BY `Customer ID`
),
rfm_score AS(
SELECT *,
CASE WHEN recency <= 10 THEN 3
WHEN recency <= 20 THEN 2
ELSE 1
END AS recency_score,

CASE WHEN num_of_orders >= 10 THEN 3
WHEN num_of_orders >= 5 THEN 2
ELSE 1
END AS frequency_score,

CASE WHEN spend_money >= 1000 THEN 3
WHEN spend_money >= 500 THEN 2
ELSE 1
END AS Monetry
FROM rfm
)
SELECT `Customer ID`,
recency,
num_of_orders,
spend_money,
recency_score,
frequency_score,
Monetry,
CONCAT(recency_score,frequency_score,Monetry) as RFM_Score
FROM
rfm_score
ORDER BY RFM_Score DESC;

/*Question 10: Customer Retention by Month
📌 Goal: Analyze how many customers returned month over month.*/
WITH customer_month AS(
SELECT `Customer ID`,
DATE_FORMAT(`Order Time`,'%Y-%m') as order_month
FROM uae_online_food_orders 
),
rank_orders as (
SELECT *,
RANK() OVER (PARTITION BY `Customer ID` ORDER BY order_month) as orders_rank
FROM customer_month
),
customer_type as (
SELECT *,
CASE WHEN orders_rank = 1 THEN 'New Customers'
ELSE 'Returning Customers'
END as customer_status
FROM rank_orders
)
SELECT order_month,
COUNT(*) as Total_Customers,
SUM(CASE WHEN customer_status = 'New Customers' THEN 1 ELSE 0 END) as New_Customers,
SUM(CASE WHEN customer_status = 'Returning Customers' THEN 1 ELSE 0 END) as Returning_Customers
FROM customer_type
GROUP BY order_month
ORDER BY order_month;

/*Question 11: Customer Churn Prediction (Advanced SQL)
Identify customers who have not placed any orders in the last 60 days (potentially churned customers).*/
SELECT `Customer ID`,
MAX(`Order Time`) as Last_placed_order,
DATEDIFF(CURRENT_DATE(),MAX(`Order Time`)) as not_placed_days
FROM uae_online_food_orders
GROUP BY `Customer ID`
HAVING not_placed_days >60
ORDER BY not_placed_days DESC;

/*Q12. Cohort Analysis: Monthly Retention
Group users by the month of their first purchase (cohort), and track how many came back in subsequent months.*/
-- Step 1: Extract customer order months and their cohort month
WITH customer_orders AS (
    SELECT 
        `Customer ID`,
        DATE_FORMAT(`Order Time`, '%Y-%m') AS order_month,  -- Month of this order
        MIN(DATE_FORMAT(`Order Time`, '%Y-%m')) OVER (PARTITION BY `Customer ID`) AS cohort_month  -- First order month (cohort)
    FROM uae_online_food_orders
),

-- Step 2: Count number of customers per cohort and month
cohort_analysis AS (
    SELECT 
        cohort_month,
        order_month,
        COUNT(DISTINCT `Customer ID`) AS active_users
    FROM customer_orders
    GROUP BY cohort_month, order_month
),

-- Step 3: Calculate months difference between cohort and order month
cohort_indexed AS (
    SELECT 
        *,
        TIMESTAMPDIFF(
            MONTH, 
            STR_TO_DATE(cohort_month, '%Y-%m'), 
            STR_TO_DATE(order_month, '%Y-%m')
        ) AS cohort_index
    FROM cohort_analysis
)

-- Final output
SELECT 
    cohort_month,
    order_month,
    cohort_index,
    active_users
FROM cohort_indexed
ORDER BY cohort_month, cohort_index;


