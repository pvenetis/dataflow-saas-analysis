/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore trends through seasonal and monthly aggregates
********************************************************************************************/

-- =========================================
-- V. TEMPORAL ANALYSIS (SEASONAL & TRENDS)
-- =========================================

-- 1. Revenue trend per year
SELECT
    YEAR(purchase_ts) AS year,
    SUM(usd_price) AS total_revenue
FROM 
    orders
GROUP BY 
    YEAR(purchase_ts)
ORDER BY 
    year;

-- 2. Monthly seasonal trend
SELECT
    DATENAME(MONTH, purchase_ts) AS month_name,
    SUM(usd_price) AS monthly_revenue
FROM 
    orders
GROUP BY 
    DATENAME(MONTH, purchase_ts), 
    MONTH(purchase_ts)
ORDER BY 
    MONTH(purchase_ts);

-- 3. Seasonal revenue summary
SELECT
    CASE 
        WHEN MONTH(purchase_ts) IN (11, 12) THEN 'Holiday'
        WHEN MONTH(purchase_ts) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(purchase_ts) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(purchase_ts) IN (9, 10) THEN 'Fall'
        ELSE 'Winter'
    END AS season,
    ROUND(SUM(usd_price), 2) AS total_revenue
FROM 
    orders
GROUP BY
    CASE 
        WHEN MONTH(purchase_ts) IN (11, 12) THEN 'Holiday'
        WHEN MONTH(purchase_ts) IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH(purchase_ts) IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH(purchase_ts) IN (9, 10) THEN 'Fall'
        ELSE 'Winter'
    END;

-- 4. Day of the week revenue trend
SELECT
    DATENAME(WEEKDAY, purchase_ts) AS weekday,
    COUNT(order_id) AS total_orders,
    SUM(usd_price) AS total_revenue
FROM 
	orders
GROUP BY 
	DATENAME(WEEKDAY, purchase_ts), 
	DATEPART(WEEKDAY, purchase_ts)
ORDER BY 
	DATEPART(WEEKDAY, purchase_ts);
