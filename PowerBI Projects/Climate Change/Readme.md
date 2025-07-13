##  Climate Change Analysis – SQL + Power BI

This project focuses on analyzing **per capita CO₂ emissions** by country over time, using advanced **SQL analytics** and interactive **Power BI dashboards**.

---

###  Dataset

* **Source**: [Our World in Data – CO₂ Emissions Dataset](https://ourworldindata.org/co2-emissions)
* **File Used**: `percapitacoemissions.csv`
* **Fields Include**:

  * `Country`
  * `Year`
  * `CO Emission` (per capita)

---

###  Objectives

* Identify emission trends per country
* Detect countries with consistent increases or decreases
* Rank countries by total or per capita CO₂ output
* Visualize global distribution of emissions

---

###  Tools Used

* **SQL**: For complex trend detection and CTE-based analysis
* **Power BI**: For visual storytelling, KPIs, heatmaps, and maps

---

###  SQL Insights (Advanced Queries)

 A few analytical tasks done in SQL:

1. **Top countries with increasing CO₂ emissions** over the last 5 years
2. **Detect countries with 3+ years of continuous decline**
3. **Trend classification**: Increasing, Decreasing, or Stable
4. **Custom views** to track 10-year progress

>  Bonus: Created SQL **views** to simulate emission trends for dynamic Power BI import.

---

###  Power BI Dashboard Highlights

####  Page 1: Global Emission Overview

* Map of CO₂ emissions (latest year)
* Top 10 emitting countries
* KPI cards: Global avg, min, max

####  Page 2: Time-Based Analysis

* Emission trends (line chart)
* Slicers by year & country
* Conditional formatting matrix heatmap

####  Page 3: Deep Insights

* Bottom N emitters
* Countries with stable emissions
* Custom DAX for data quality and performance

---

###  DAX Measures Used

* `LatestCO2`
* `CO2_NonZero`
* `CO2Growth %`
* `FirstYear`, `LastYear`
* `AvgCO2 by Country`
* `Status = Increasing / Decreasing`

---

###  Learnings & Concepts Applied

* Window functions in SQL (`LAG`, `LEAD`, CTEs)
* Complex DAX with `CALCULATE`, `FILTER`, `USERELATIONSHIP`
* Relationship modeling with **Star Schema**
* Interactive slicers and **cross-filtering**
* Power BI **conditional formatting + heatmap styling**

---

###  Conclusion

This project showcases how to turn raw emissions data into a powerful environmental insight tool using both SQL and Power BI.

