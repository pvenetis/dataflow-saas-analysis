/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore product-level trends and pricing behaviors.
********************************************************************************************/

-- =========================================
-- III. PRODUCT PERFORMANCE ANALYSIS
-- =========================================

-- 1. Revenue by product per month
SELECT
    p.product_name,
    YEAR(o.purchase_ts) AS year,
    MONTH(o.purchase_ts) AS month,
    SUM(o.usd_price) AS monthly_revenue
FROM 
    orders o
JOIN 
    products p 
    ON o.product_id = p.product_id
GROUP BY 
    p.product_name, 
    YEAR(o.purchase_ts), 
    MONTH(o.purchase_ts)
ORDER BY 
    p.product_name, 
    year, 
    month;

-- 2. Product-level performance summary
DECLARE @total_revenue FLOAT = (SELECT SUM(usd_price) FROM orders);

SELECT
    p.product_name,
    ROUND(SUM(o.usd_price), 2) AS revenue,
    ROUND(SUM(o.usd_price) * 100.0 / @total_revenue, 2) AS revenue_pct,
    ROUND(SUM(o.usd_price) / COUNT(o.order_id), 2) AS AOV,
    COUNT(o.order_id) AS order_count,
    ROUND(COUNT(o.refund_ts) * 100.0 / COUNT(o.order_id), 2) AS refund_rate_pct
FROM 
    orders o
JOIN 
    products p 
    ON o.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    revenue_pct DESC;

-- 3. Product contribution to total revenue
SELECT
    p.product_name,
    ROUND(SUM(o.usd_price) * 100.0 / (SELECT SUM(usd_price) FROM orders), 2) AS revenue_pct
FROM 
    orders o
JOIN 
    products p 
    ON o.product_id = p.product_id
GROUP BY 
    p.product_name
ORDER BY 
    revenue_pct DESC;

-- 4. Average price per product
SELECT
	p.product_name,
	ROUND(AVG(usd_price), 2) as avg_price,
	COUNT(o.order_id) as total_orders
FROM
	orders o
JOIN
	products p
	ON o.product_id = p.product_id
GROUP BY
	p.product_name
ORDER BY
	avg_price DESC;