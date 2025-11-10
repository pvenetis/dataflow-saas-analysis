/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore sales trends by national and regional data.
********************************************************************************************/

-- =========================================
-- IV. GEOGRAPHICAL INSIGHTS
-- =========================================

-- 1. Revenue share per region (percentage of total)
SELECT
	c.region,
	SUM(usd_price) as total_revenue,
	ROUND(SUM(usd_price) / (SELECT SUM(usd_price) FROM orders) * 100.0, 2) as pct_of_total
FROM
	orders o
JOIN
	country_lookup c
	ON o.country_code = c.alpha_2
GROUP BY
	c.region
ORDER BY
	pct_of_total DESC;

-- 2. Top countries by average order value
SELECT
    c.country,
    ROUND(SUM(o.usd_price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM 
    orders o
JOIN 
    country_lookup c 
    ON o.country_code = c.alpha_2
GROUP BY 
    c.country
ORDER BY 
    avg_order_value DESC;

-- 3a. Product popularity by region (all products)
--     Shows total orders and revenue for every product across regions.
SELECT
    c.region,
    p.product_name,
    COUNT(*) AS num_orders,
    ROUND(SUM(o.usd_price), 2) AS total_revenue
FROM 
    orders o
JOIN 
    products p 
    ON o.product_id = p.product_id
JOIN 
    country_lookup c 
    ON o.country_code = c.alpha_2
GROUP BY 
    c.region, 
    p.product_name
ORDER BY 
    c.region, 
    total_revenue DESC;

-- 3b. Top product per region (by order volume and revenue)
--     Uses ranking to identify top products for each region.
WITH regional_product_count AS
(
	SELECT
		c.region,
		p.product_name,
		COUNT(o.order_id) as order_count,
		SUM(usd_price) as total_revenue
	FROM 
		orders o
	JOIN 
		products p 
		ON o.product_id = p.product_id
	JOIN 
		country_lookup c 
		ON o.country_code = c.alpha_2
	GROUP BY
		c.region,
		p.product_name
),
ranked_products AS
(
	SELECT
		region,
		product_name,
		RANK()
		OVER(PARTITION BY region ORDER BY order_count DESC) as count_rank,
		RANK()
		OVER(PARTITION BY region ORDER BY total_revenue DESC) as revenue_rank
	FROM
		regional_product_count
)
SELECT *
FROM
	ranked_products
WHERE
	count_rank = 1 
	OR revenue_rank = 1

-- 4. Refunds, revenue, and volume by region and loyalty
SELECT
    c.region,
    o.loyalty_program,
    COUNT(DISTINCT o.customer_id) AS customers,
    COUNT(o.order_id) AS total_orders,
    SUM(o.usd_price) AS revenue,
    COUNT(o.refund_ts) AS refund_count,
    ROUND(COUNT(o.refund_ts) * 100.0 / COUNT(o.order_id), 2) AS refund_rate_pct
FROM
    orders o
JOIN country_lookup c
    ON o.country_code = c.alpha_2
GROUP BY
    c.region,
    o.loyalty_program
ORDER BY
    o.loyalty_program,
    revenue DESC;

-- 5. Top performing countries per region by revenue

DECLARE @total_revenue FLOAT = (SELECT SUM(usd_price) FROM orders);
SELECT
	c.region,
	c.country,
	ROUND(SUM(o.usd_price), 2) AS revenue,
    ROUND(SUM(o.usd_price) * 100.0 / @total_revenue, 2) AS revenue_pct,
    ROUND(SUM(o.usd_price) / COUNT(o.order_id), 2) AS AOV
FROM
    orders o
JOIN country_lookup c
    ON o.country_code = c.alpha_2
GROUP BY
    c.region,
	c.country
ORDER BY
	c.region,
	revenue_pct DESC,
	c.country;