# DataFlow SaaS Performance Analysis

> For more of my projects and analytics journey, visit my [Portfolio](https://pvenetis.github.io/).

---

### Table of Contents
- [Project Background](#project-background)
- [Executive Summary](#executive-summary)
- [Data Model Overview](#data-model-overview)
- [Insights Deep-Dive](#insights-deep-dive)
  - [Sales Trends and Growth Rates](#sales-trends-and-growth-rates)
  - [Product Performance](#product-performance)
  - [Regional Insights](#regional-insights)
  - [Loyalty Program and Refund Analysis](#loyalty-program-and-refund-analysis)
  - [Seasonality Analysis](#seasonality-analysis)
- [Recommendations](#recommendations)

---

## Project Background

**DataFlow Cloud** is a B2B SaaS company providing cloud-based solutions that help organizations simplify **data integration, analytics, and workflow automation**.  

Between **2022 and 2025**, the company processed over **120,000 customer orders** across five major regions — **Africa, the Americas, Asia, Europe, and Oceania**.  

This analysis explores **sales performance, regional behavior, customer loyalty, and refund trends** to uncover key growth opportunities and operational improvements.

*(Note: Data is simulated to reflect realistic SaaS business patterns.)*

---

## Methodology & Tools

This analysis combined **data preparation, exploratory analysis, and business insights** using the following approach:

- **Data Cleaning & Preparation:** SQL was used to profile the data, assess data quality, remove duplicates, normalize tables, and validate consistency across **Orders**, **Products**, and **Country Lookup**.  
- **Exploratory Data Analysis (EDA):** SQL queries (joins, CTEs, window functions) were used to uncover trends in revenue, order volume, product performance, and refund behavior.  
- **Excel Modeling:** Query results were exported into Excel for additional analysis using formulas, Power Query, pivot tables, and charts.  
- **Insight Generation:** Metrics such as **Average Order Value (AOV)**, refund rate, and product ranking were calculated to support strategic recommendations.  
- **Visualization:** Excel charts and tables were created to highlight the most meaningful patterns, and a Power BI dashboard is being developed for interactive exploration.  

**Tools & Technologies:** SQL Server, Excel, GitHub, Markdown, Power BI

---

## Executive Summary

Analysis of 120K+ orders (2022–2025) shows that **growth is driven more by upselling existing customers to high-tier Enterprise Plans than by new order volume**, indicating strong retention and customer trust, alongside clear seasonal and regional patterns.

### Key Insights

- **Enterprise Plan** contributes 26.5% of total revenue — confirming its strategic importance for growth.  
- Upselling mid-tier customers drives AOV growth, while order volume remains evenly distributed (~12K orders per product).  
- **Europe** leads revenue, reflecting strong enterprise adoption and consistently low refunds.  
- **Africa** overperforms relative to expectations, highlighting early-stage adoption and SME growth potential.  
- Seasonal trends show summer revenue peaks, with winter consistently slower.  
- Stable refund rates (4.9%–5.3%) suggest strong overall customer satisfaction.

### Takeaway

DataFlow Cloud demonstrates **high-value enterprise traction, effective retention, and scalable opportunities in emerging markets**.

---

### Data Model Overview

The database design centers around four key entities — **Orders**, **Products**, and **Customers** linked by primary and foreign keys for clean relational structure.

![Entity Relationship Diagram](./Visuals/ERD_diagram.png)  
*ERD highlighting the relationships between key tables.*

---

## Insights Deep-Dive

### Sales Trends and Growth Rates

Revenue shows a steady upward trajectory from 2022 to 2025, rising from $8.3M to over $10M annually before 2025’s partial-year slowdown.

**Insights:**

- Recurring **summer peaks** and strong November–December performance reflect seasonal spending and renewal cycles.  
- **AOV variation** (~$160–$815) highlights the impact of product tier and upselling strategies.  
- Growth is driven more by **upselling than new order volume**, indicating strong retention.  
- Year-end spikes are heavily influenced by **enterprise contract renewals**, aligning with subscription cycles.

![Monthly Revenue Trend](./Visuals/Monthly%20Revenue%20Trend.PNG)  
*Monthly revenue trend from 2022–2025 showing seasonal peaks.*

---

### Product Performance

Analysis shows a **top-heavy revenue structure**, but balanced order volumes across products.

**Insights:**

- **Enterprise Plan** is the primary revenue driver: $9.74M (26.5%), with the highest AOV ($815).  
- **Email Automation** leads in order count (12,220) but contributes only ~5% of revenue, suggesting many entry-level clients with lower spend.  
- Mid-tier products (**Pro Plan, API Access, AI Insights**) maintain steady adoption (~12K orders each), supporting upselling paths.  
- Stable refund rates (4.7%–5.4%) across all products indicate healthy product satisfaction and minimal performance issues.

![Product Performance Summary](./Visuals/Product%20Performance%20Summary.PNG)  
*Overview of key performance metrics across all products.*

---

### Regional Insights

| Region   | Top Product (Revenue) | Top Product (Orders) |
|----------|------------------------|------------------------|
| Africa   | Enterprise Plan        | Email Automation       |
| Americas | Enterprise Plan        | Email Automation       |
| Asia     | Enterprise Plan        | API Access             |
| Europe   | Enterprise Plan        | Starter Plan           |
| Oceania  | Enterprise Plan        | Email Automation       |

Regional analysis reveals **market segmentation and growth opportunities**:

- **Europe**: $13.47M revenue, ~44K orders, low refund rate (4.96%) → mature enterprise market with strong product-market fit.  
- **Americas**: $8.6M revenue, slightly higher refunds (5.30%) → stable but can improve retention.  
- **Africa**: $7.31M revenue → surprising SME adoption suggests potential for upselling enterprise packages.  
- **Asia**: $4.9M revenue → high SME activity and entry-level product adoption; strong potential for enterprise expansion.  
- **Oceania**: $2.46M revenue → niche but consistent, providing stable recurring revenue.

**Insight:** Enterprise-heavy regions drive most revenue, while emerging markets show strong adoption potential. Targeted upselling and regional customization could maximize growth.

| ![Revenue by Region](./Visuals/Revenue%20by%20Region.PNG) | ![Product Volume by Region](./Visuals/Product%20Volume%20by%20Region.PNG) |
|---|---|
| *Regional revenue distribution across five major markets.* | *Regional comparison of total orders, highlighting strong SME presence in Asia-Pacific.* |

---

### Loyalty Program and Refund Analysis

Refund behavior across regions shows **stable performance**, with all markets falling between **4.96% and 5.30%**.

**Key insights:**

- **Americas** has the highest refund rate (5.30%), potentially reflecting higher product trial usage or stricter customer expectations.  
- **Europe** combines the highest revenue with a below-average refund rate (4.96%), signaling a satisfied, high-value enterprise customer base.  
- No region exhibits dangerous refund spikes, indicating **consistent global customer satisfaction**.  

![Refund Rate by Region](./Visuals/Refund%20Rate%20by%20Region.PNG)  
*Refund rates remain low across regions, with minor variations.*

---

### Seasonality Analysis

Revenue follows a clear seasonal structure, driven by purchasing cycles and organizational budgets.  

**Insights:**

- **Summer** is the strongest season, generating the highest revenue across all years.  
- **Winter** consistently shows the lowest revenue, reflecting slower business activity.  
- **Holiday season** (Nov–Dec) provides a reliable secondary peak, though it is not as pronounced as summer.  

| ![Seasonal Revenue (%) Chart](./Visuals/Seasonal%20Revenue%20(%25).PNG) | ![Seasonal Revenue Bar Chart](./Visuals/Seasonal%20Revenue%20Bar%20Chart.PNG) |
|---|---|
| *Percentage distribution of revenue across seasons, highlighting summer dominance.* | *Bar chart representation of seasonal revenue trends.* |

---

## Recommendations

### 1. Strengthen Enterprise Offerings
- Launch **custom analytics dashboards** for Enterprise clients.  
- Offer **multi-year renewal discounts** to secure long-term contracts.  

### 2. Expand in Asia-Pacific
- Use **localized marketing** and **SME-targeted bundles** (Workflow + Email Automation).  
- Partner with **regional resellers** to provide localized support and accelerate adoption.  

### 3. Improve Refund Monitoring
- Implement **refund prediction models** to anticipate churn.  
- Collect **qualitative feedback** to guide retention strategies.  

### 4. Boost Loyalty Program Engagement
- Introduce **tiered membership levels** (Silver, Gold, Platinum) with incremental perks.  
- Reward engagement with **credit-based renewal bonuses**.  

### 5. Product Diversification and Cross-Selling
- Bundle lower-tier services for **discounted offers**.  
- Upsell **AI Insights** to Workflow Automation clients to increase AOV.

---

## Project Reflection

This project reinforced my ability to **transform raw data into actionable business insights**, connecting SQL queries and Excel analysis to meaningful recommendations.  

**Key takeaways:**
- Recognizing regional differences and seasonal trends.  
- Understanding loyalty program impact on revenue and retention.  
- Crafting **data-driven narratives** that explain the “why” behind trends.

Future analysis could incorporate **predictive modeling** and multi-metric visualizations for enhanced strategic decision-making.

---

**See the raw data and analysis artifacts:**
- 📊 [Excel Workbook with Pivot Tables](./EDA/EDA_Sales_Insights.xlsx)  
- 🧠 [SQL Queries](./SQL)  
- 🧾 [Data Preparation Files](./Data/Profiling_and_Cleaning)  
- 📈 [Power BI Dashboard](./Dashboard)

---

*© 2025 Peri Venetis – DataFlow Cloud SaaS Analysis Project*
