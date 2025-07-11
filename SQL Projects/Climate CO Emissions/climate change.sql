USE climate;
SELECT * FROM percapitacoemissions;

ALTER TABLE percapitacoemissions
RENAME COLUMN Entity TO Country;

ALTER TABLE percapitacoemissions
RENAME COLUMN `Annual COâ‚‚ emissions (per capita)` TO `CO Emission`;

-- Q1. Top 5 Countries with Highest Average CO₂ per Capita in the Last 10 Years
SELECT `Country`, ROUND(AVG(`CO Emission`),2) as AVG_CO_EMISSION
FROM percapitacoemissions
WHERE `Year`>2013
GROUP BY `Country`
ORDER BY AVG_CO_EMISSION DESC
LIMIT 10;

-- Bonus Question to find average co emmision in NEPAL
SELECT `Country`, ROUND(AVG(`CO Emission`),2) as AVG_CO_EMISSION
FROM percapitacoemissions
WHERE `Country`='Nepal';

-- Q2. Countries with Constant Growth in CO₂ per Capita for the Past 5 Years
WITH RankedData AS (
  SELECT `Country`, `Year`, `CO Emission`,
         LAG(`CO Emission`) OVER (PARTITION BY Country ORDER BY Year) AS prev_emission
  FROM percapitacoemissions
  WHERE year >= 2018
)
SELECT `Country`,
       COUNT(*) AS years_of_growth
FROM RankedData
WHERE `CO Emission` > prev_emission
GROUP BY Country
HAVING COUNT(*) >= 4;

-- Q.3 Calculate Year-over-Year Change in Per Capita CO₂ Emissions for Each Country

SELECT `Country`,`Year`,`CO Emission`,
LAG(`CO Emission`) OVER (PARTITION BY `Country` ORDER BY `Year`) as Prev_Year,
(`CO Emission` - LAG(`CO Emission`) OVER (PARTITION BY `Country` ORDER BY `Year`)) AS coemissionchange
FROM percapitacoemissions

-- Q.4 Global Average CO₂ Emissions per Capita by Year

SELECT `Year`,AVG(`CO Emission`) AS avg_emission
FROM percapitacoemissions
GROUP BY `Year` 
ORDER BY avg_emission DESC;

-- Q.5 Compare Maximum emissions in 2000 vs 2020
WITH Yearly AS(
SELECT `Country`,
MAX(CASE WHEN `Year`="2000" THEN `CO Emission` END) AS year2000,
MAX(CASE WHEN `Year`="2020" THEN `CO Emission` END) AS year2020
FROM percapitacoemissions
GROUP BY `Country`
)
SELECT `Country`,year2000,year2020,
(year2020-year2000) AS coemissionchange
FROM Yearly
WHERE year2000 is not null and year2020 is not null
ORDER BY coemissionchange DESC;

-- Q6. Find countries that had a decrease in CO₂ per capita for at least 3 out of the last 5 years.
WITH RankedData AS (
  SELECT `Country`, `Year`, `CO Emission`,
         LAG(`CO Emission`) OVER (PARTITION BY Country ORDER BY Year) AS prev_emission
  FROM percapitacoemissions
  WHERE year >= 2018
)
SELECT `Country`,
       COUNT(*) AS years_of_decline
FROM RankedData
WHERE `CO Emission` < prev_emission
GROUP BY Country
HAVING COUNT(*) >= 3;
-- --------------------------another way for reusuable-------------------------------------------------------
WITH Last5 AS (
  SELECT *,
         LAG(`CO Emission`) OVER (PARTITION BY `Country` ORDER BY `Year`) AS prev_year
  FROM percapitacoemissions
  WHERE `Year` >= 2018
),
Changes AS (
  SELECT `Country`,
         `Year`,
         `CO Emission`,
         prev_year,
         CASE 
           WHEN `CO Emission` < prev_year THEN 1
           ELSE 0
         END AS decrease
  FROM Last5
  WHERE prev_year IS NOT NULL
)
SELECT `Country`,
       SUM(decrease) AS decrease_years
FROM Changes
GROUP BY `Country`
HAVING SUM(decrease) >= 3
ORDER BY decrease_years DESC;

-- Q7. Which countries had the highest average CO₂ emissions per capita over the last 10 years?
WITH Last10 AS(
SELECT *
FROM percapitacoemissions
WHERE `Year`>=2012
),
avg_emission AS (
SELECT `Country`,
AVG(`CO Emission`) as avg_emission_10
FROM Last10
GROUP BY `Country`
)
SELECT * 
FROM avg_emission
ORDER BY avg_emission_10 DESC
LIMIT 10;

-- Q8. Find countries that had zero CO₂ emissions per capita for at least 10 different years.
WITH Last10 AS (
  SELECT *
  FROM percapitacoemissions
  WHERE `Year` >= 2012
),
ZeroEmission AS (
  SELECT `Country`,
         CASE 
           WHEN `CO Emission` = 0 THEN 1 
           ELSE 0 
         END AS zero_flag
  FROM Last10
)
SELECT Country,
       SUM(zero_flag) AS zero_years
FROM ZeroEmission
GROUP BY `Country`
HAVING SUM(zero_flag) >= 10
ORDER BY zero_years DESC;
-- ---------------------------------------Alternative Way-------------------------------------------
SELECT `Country`,`CO Emission`,
COUNT(*) AS zeroemission FROM percapitacoemissions
WHERE `CO Emission`=0
GROUP BY `Country`
HAVING COUNT(*)>=10;


-- Q9. Find countries where CO₂ per capita increased every year for the last 5 years (2018–2022)
WITH Last5 AS (
  SELECT *,
         LAG(`CO Emission`) OVER (PARTITION BY `Country` ORDER BY `Year`) AS Prev_Emission
  FROM percapitacoemissions
  WHERE `Year` >= 2018
),
growth AS (
  SELECT `Country`,
         CASE 
           WHEN `CO Emission` > Prev_Emission THEN 1 
           ELSE 0 
         END AS grew
  FROM Last5
  WHERE Prev_Emission IS NOT NULL
)
SELECT `Country`,
       COUNT(*) AS growth_years,
       SUM(grew) AS grew_count
FROM growth
GROUP BY `Country`
HAVING COUNT(*) = 4 AND SUM(grew) = 4
ORDER BY grew_count DESC;

/* Q.10 Create a view that tracks each country's year-over-year (YOY) CO₂ per capita change over the last 10 years,
 and labels each year as:
"Increasing", "Decreasing", or "Stable".*/
CREATE VIEW Emission10 AS
WITH Last10 AS(
SELECT `Country`,`Year`,`CO Emission` AS currentyrs,
LAG(`CO Emission`) OVER (PARTITION BY `Country` ORDER BY `Year`) AS previousyrs
FROM percapitacoemissions
WHERE `Year` >= (
SELECT MAX(`Year`) FROM percapitacoemissions) - 9
) ,

trend AS(
SELECT `Country`,`Year`,
CASE WHEN currentyrs  > previousyrs THEN 'Increasing'
	WHEN currentyrs < previousyrs THEN 'Decreasing'
	ELSE
	'Stable' END AS statusyrs
FROM LAST10
WHERE previousyrs IS NOT NULL
 )
SELECT * FROM trend;

SELECT * FROM emission10 WHERE `Country`='Nepal';