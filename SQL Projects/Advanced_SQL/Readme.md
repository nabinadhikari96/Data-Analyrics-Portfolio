# UAE Online Food Orders — SQL Analysis Project

This repository contains a complete **SQL-based analytics project** on a simulated real-world **UAE online food ordering** dataset. The project focuses on business-driven data analysis using **advanced SQL techniques** to extract actionable insights from dirty, unstructured data.

> 📢 *This project mimics real-world scenarios with messy datasets—perfect for aspiring data analysts or business intelligence professionals.*

---

## 🔍 Dataset Overview

The dataset (`uae_online_food_orders.csv`) contains records of online food transactions in the UAE. It includes fields such as:

* `Order ID`, `Customer ID`
* `Item Name`, `Quantity`, `Price`
* `Order Time`, `Branch`, `Payment Method`
* `Discount`, `Delivery Time`, and more...


## 🧠 SQL Analyses Performed

### ✅ 1. RFM Segmentation

* Recency, Frequency, and Monetary scoring
* Customer ranking and loyalty segmentation

### ✅ 2. Cohort Analysis

* Monthly customer acquisition
* Retention behavior and lifecycle indexing

### ✅ 3. Customer Churn Detection

* Identifying customers who haven’t ordered in the last 60 days
* Targeting for retention strategies

### ✅ 4. Product Affinity / Item Pairing

* Detecting frequently ordered item combinations
* Market basket analysis logic using self-joins

### ✅ 5. New vs Returning Customers

* Classifying monthly orders as "New" or "Returning"
* Monthly trend visualization ready

---

## 🧮 SQL Features Used

* Common Table Expressions (CTEs)
* Window Functions (`RANK`, `ROW_NUMBER`)
* Aggregation & Filtering (`GROUP BY`, `HAVING`)
* Conditional Logic (`CASE WHEN`)
* Joins (including self-joins for product pairing)
* Date/Time Manipulations

---

## 📊 Power BI Integration (Coming Soon)

> ⚙️ Although this project is **100% SQL-based**, the resulting tables and logic are ready to be imported into **Power BI** for interactive dashboards and business visualizations.

Power BI tasks (coming next):

* Customer retention dashboard
* RFM segmentation visuals
* Churn rate trend analysis
* Item combo heatmap

