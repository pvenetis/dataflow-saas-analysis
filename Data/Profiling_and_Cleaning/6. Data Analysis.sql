-- ***********************************************************************************************************
-- STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
-- Exploring sales performance, product trends, and pricing behavior
-- ***********************************************************************************************************

-- =========================================
-- I. SALES PERFORMANCE ANALYSIS
-- =========================================

-- 1️. What is the total revenue, average order value (AOV), and total orders over time?
SELECT 
	YEAR(purchase_ts) AS year,
	DATENAME(MONTH, purchase_ts) AS month,
	SUM(usd_price) AS total_revenue,
	COUNT(DISTINCT order_id) AS total_orders,
	ROUND(SUM(usd_price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM orders
WHERE refund_ts IS NULL
GROUP BY YEAR(purchase_ts), MONTH(purchase_ts), DATENAME(MONTH, purchase_ts)
ORDER BY 
	year, 
	MONTH(purchase_ts);

-- Insight:



-- 2️. How is revenue trending month-over-month and year-over-year?
SELECT 
	YEAR(purchase_ts) AS year,
	DATENAME(MONTH, purchase_ts) AS month,
	SUM(usd_price) AS revenue
FROM orders
WHERE refund_ts IS NULL AND purchase_ts IS NOT NULL
GROUP BY YEAR(purchase_ts), MONTH(purchase_ts), DATENAME(MONTH, purchase_ts)
ORDER BY year, MONTH(purchase_ts);
-- Insight:



-- 3️. Which products are generating the most revenue?
SELECT
	p.product_name,
	SUM(o.usd_price) AS total_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
-- Insight:



-- 4️. Which products are selling most frequently (volume vs. value)?
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
-- Insight:



-- 5️. What is the average monthly revenue per year?
SELECT 
	YEAR(purchase_ts) AS year,
	DATENAME(MONTH, purchase_ts) AS month,
	ROUND(AVG(usd_price), 2) AS avg_revenue_per_order
FROM 
	orders
WHERE 
	refund_ts IS NULL
	AND purchase_ts IS NOT NULL
GROUP BY 
	YEAR(purchase_ts), 
	DATENAME(MONTH, purchase_ts),
	MONTH(purchase_ts)
ORDER BY 
	year, 
	MONTH(purchase_ts);
-- Insight:



-- 6️. Which currencies are used most?
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

-- Insight:


-- =========================================
-- SUMMARY OF FINDINGS
-- =========================================

