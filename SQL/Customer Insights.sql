/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore customer behavior and patterns.
********************************************************************************************/

-- =========================================
-- II. CUSTOMER INSIGHTS
-- =========================================

-- 1. Total unique customers
SELECT 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM 
    orders;

-- 2. Most loyal or highest-spending customers (repeat buyers)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(usd_price) AS total_spent
FROM 
    orders
GROUP BY 
    customer_id
HAVING 
    COUNT(order_id) > 1
ORDER BY 
    total_spent DESC;

-- 3. Revenue by marketing channel
SELECT
    marketing_channel,
    ROUND(SUM(usd_price), 2) AS total_revenue,
    COUNT(*) AS num_orders
FROM 
    orders
GROUP BY 
    marketing_channel
ORDER BY 
    total_revenue DESC;

-- 4. Average spend by account creation method
SELECT
    account_creation_method,
    ROUND(AVG(usd_price), 2) AS avg_spend
FROM 
    orders
GROUP BY 
    account_creation_method
ORDER BY 
    avg_spend DESC;

-- 5a. Correlation with product refund rates and loyalty program status
SELECT
	p.product_name,
	o.loyalty_program,
	ROUND(CONVERT(FLOAT, COUNT(o.refund_ts)) / COUNT(o.order_id) * 100, 2) as refund_rate,
	COUNT(o.refund_ts) as refund_count,
	COUNT(o.order_id) as order_count
FROM
	orders o
JOIN products p
	ON o.product_id = p.product_id
GROUP BY
	p.product_name,
	o.loyalty_program
ORDER BY
	p.product_name,
	o.loyalty_program;

-- 5b. Correlation with annual refund rates and loyalty program status
SELECT
	YEAR(purchase_ts) as year,
	o.loyalty_program,
	ROUND(CONVERT(FLOAT, COUNT(o.refund_ts)) / COUNT(o.order_id) * 100, 2) as refund_rate,
	COUNT(o.refund_ts) as refund_count,
	COUNT(o.order_id) as order_count
FROM
	orders o
GROUP BY
	YEAR(purchase_ts),
	o.loyalty_program
ORDER BY
	year,
	o.loyalty_program;

-- 6. Percentage of customers with more than one order per year
WITH multi_order_customers AS 
(
    SELECT
        YEAR(purchase_ts) AS year,
        customer_id,
        COUNT(order_id) AS order_count
    FROM 
		orders
    GROUP BY
        YEAR(purchase_ts),
        customer_id
    HAVING COUNT(order_id) > 1
),
total_customers_by_year AS 
(
    SELECT
        YEAR(purchase_ts) AS year,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM 
		orders
    GROUP BY
        YEAR(purchase_ts)
)
SELECT
    m.year,
    COUNT(DISTINCT m.customer_id) AS num_customers_more_than_one_order,
    t.total_customers,
    ROUND(COUNT(DISTINCT m.customer_id) * 100.0 / t.total_customers, 2) AS pct_customers_more_than_one_order
FROM 
	multi_order_customers m
JOIN 
	total_customers_by_year t
    ON m.year = t.year
GROUP BY
    m.year, 
	t.total_customers
ORDER BY
    m.year;
	
-- 7. Regional customer distribution
SELECT 
    c.region,
    COUNT(DISTINCT o.customer_id) AS total_customers
FROM
	orders o
JOIN 
	country_lookup c 
	ON o.country_code = c.alpha_2
GROUP BY 
	c.region
ORDER BY 
	total_customers DESC;

-- 8. Repeat customer percentage by region
WITH repeat_customers AS (
    SELECT
        c.region,
        o.customer_id
    FROM 
		orders o
    JOIN 
		country_lookup c 
		ON o.country_code = c.alpha_2
    GROUP BY 
		c.region, 
		o.customer_id
    HAVING COUNT(o.order_id) > 1
),
total_customers AS (
    SELECT
        c.region,
        COUNT(DISTINCT o.customer_id) AS total_customers
    FROM 
		orders o
    JOIN 
		country_lookup c 
		ON o.country_code = c.alpha_2
    GROUP BY 
		c.region
)
SELECT 
    t.region,
    COUNT(DISTINCT r.customer_id) AS repeat_customers,
    t.total_customers,
    ROUND(COUNT(DISTINCT r.customer_id) * 100.0 / t.total_customers, 2) AS repeat_customer_pct
FROM 
	total_customers t
LEFT JOIN 
	repeat_customers r 
	ON t.region = r.region
GROUP BY 
	t.region, 
	t.total_customers
ORDER BY 
	repeat_customer_pct DESC;
