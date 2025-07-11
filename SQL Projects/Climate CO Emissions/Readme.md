
## 🌍 Climate Change SQL Project – CO₂ Per Capita Analysis

### 📘 Overview

This project analyzes per capita CO₂ emissions by country over time using advanced SQL techniques. It helps identify global emission trends, detect year-over-year changes, and label countries based on increasing, decreasing, or stable emissions.

### 📂 Dataset Used

* Source: [Our World in Data – CO₂ Emissions Dataset](https://ourworldindata.org/co2-and-other-greenhouse-gas-emissions) 
* Columns used: `Country`, `Year`, `CO Emission`

---

### 🔍 Key SQL Techniques

* `LAG()` window function for year-over-year comparisons
* `CASE WHEN` statements for labeling trends
* `WITH` Common Table Expressions (CTEs) for stepwise logic
* Aggregate functions like `SUM()`, `COUNT()`
* `VIEW` creation to track emission trends by year

---

### 📊 Insights You Can Derive

* Countries with increasing or decreasing CO₂ per capita
* Countries with consistent growth or decline over the past 5–10 years
* Yearly emission trend labels for any country
* Zero-emission years and emission volatility

---

### 🧠 Example Output from Trend View

| Country | Year | currentyrs | previousyrs | statusyrs  |
| ------- | ---- | ---------- | ----------- | ---------- |
| India   | 2019 | 1.69       | 1.67        | Increasing |
| India   | 2020 | 1.60       | 1.69        | Decreasing |
| India   | 2021 | 1.61       | 1.60        | Increasing |
