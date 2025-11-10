/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore sales performance, product trends, pricing behavior, and currency usage.
********************************************************************************************/

-- =========================================
-- I. SALES PERFORMANCE ANALYSIS
-- =========================================

-- 1. Total revenue, average order value (AOV), and total orders by month and year
SELECT 
    YEAR(purchase_ts) AS year,
    DATENAME(MONTH, purchase_ts) AS month,
    SUM(usd_price) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(usd_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM 
	orders
WHERE 
	refund_ts IS NULL
GROUP BY 
    YEAR(purchase_ts), 
    MONTH(purchase_ts),
    DATENAME(MONTH, purchase_ts)
ORDER BY 
    year, 
    MONTH(purchase_ts);

-- 2a. Revenue trends year-over-year
WITH yearly_revenue AS
(
	SELECT 
		YEAR(purchase_ts) AS year,
		SUM(usd_price) AS total_revenue
	FROM 
		orders
	WHERE 
		refund_ts IS NULL 
		AND purchase_ts IS NOT NULL
	GROUP BY 
		YEAR(purchase_ts)
)
SELECT
	year,
	total_revenue,
	LAG(total_revenue)
	OVER(ORDER BY year) as prev_year_rev,
	ROUND(
		(total_revenue - LAG(total_revenue) OVER(ORDER BY year)) 
		/ NULLIF(LAG(total_revenue) OVER(ORDER BY year), 0) * 100, 
	2) as yoy_growth_pct
FROM
	yearly_revenue
ORDER BY
	year;

-- 2b. Revenue trends month-over-month
WITH revenue_by_month AS (
    SELECT 
        YEAR(purchase_ts) AS year,
        MONTH(purchase_ts) AS month_num,
		DATENAME(MONTH, purchase_ts) as month,
        SUM(usd_price) AS total_revenue
    FROM 
		orders
    WHERE 
		refund_ts IS NULL
    GROUP BY 
		YEAR(purchase_ts), 
		MONTH(purchase_ts),
		DATENAME(MONTH, purchase_ts)
)
SELECT
    year,
    month,
    total_revenue,
    LAG(total_revenue) 
	OVER (ORDER BY year, month_num) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month_num)) 
        / NULLIF(LAG(total_revenue) OVER (ORDER BY year, month_num), 0) * 100, 
    2) AS mom_growth_pct
FROM 
	revenue_by_month
ORDER BY 
	year, 
	month_num;


-- 3. Top revenue-generating products
SELECT
    p.product_name,
    SUM(o.usd_price) AS total_revenue
FROM 
	orders o
JOIN 
	products p 
    ON o.product_id = p.product_id
GROUP BY 
	p.product_name
ORDER BY 
	total_revenue DESC;

-- 4. Products with highest sales volume vs. revenue
SELECT
    p.product_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.usd_price) AS total_revenue
FROM 
	orders o
JOIN 
	products p 
    ON o.product_id = p.product_id
GROUP BY 
	p.product_name
ORDER BY 
	total_orders DESC;

-- 5. Average monthly revenue per order
SELECT 
    YEAR(purchase_ts) AS year,
    DATENAME(MONTH, purchase_ts) AS month,
    ROUND(AVG(usd_price), 2) AS avg_revenue_per_order
FROM 
	orders
WHERE 
	refund_ts IS NULL AND purchase_ts IS NOT NULL
GROUP BY 
    YEAR(purchase_ts), 
    MONTH(purchase_ts),
    DATENAME(MONTH, purchase_ts)
ORDER BY 
    year, 
    MONTH(purchase_ts);

-- 6. Most used currencies
SELECT 
    currency,
    COUNT(order_id) AS total_orders
FROM 
	orders
WHERE 
	refund_ts IS NULL
GROUP BY 
	currency
ORDER BY 
	total_orders DESC;




