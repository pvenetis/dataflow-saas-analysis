/*******************************************************************************************
STEP 6: EXPLORATORY DATA ANALYSIS (EDA)
Objective: Explore shipping and delivery times.
********************************************************************************************/

-- =========================================
-- VI. OPERATIONAL METRICS
-- =========================================

-- 1. Average shipping and delivery time
SELECT
    ROUND(AVG(DATEDIFF(DAY, purchase_ts, ship_ts)), 2) AS avg_ship_days,
    ROUND(AVG(DATEDIFF(DAY, ship_ts, delivery_ts)), 2) AS avg_delivery_days
FROM 
    orders
WHERE 
    ship_ts IS NOT NULL 
    AND delivery_ts IS NOT NULL;

-- 2. Refund rate
SELECT
    ROUND(100.0 * SUM(CASE WHEN refund_ts IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS refund_rate_pct
FROM 
    orders;

-- 3. Delivery delays by region
SELECT
    c.region,
    ROUND(AVG(DATEDIFF(DAY, ship_ts, delivery_ts)), 2) AS avg_delivery_days
FROM 
    orders o
JOIN 
    country_lookup c 
    ON o.country_code = c.alpha_2
WHERE 
    ship_ts IS NOT NULL 
    AND delivery_ts IS NOT NULL
GROUP BY 
    c.region
ORDER BY 
    avg_delivery_days DESC;

-- 4. Refunds by region
SELECT
	c.region,
	COUNT(o.refund_ts) as total_refunds,
	ROUND(COUNT(o.refund_ts) * 100.0 / COUNT(o.order_id) , 2) as refund_rate_pct
FROM
	orders o
JOIN country_lookup c
	ON o.country_code = c.alpha_2
GROUP BY
	c.region
ORDER BY
	refund_rate_pct DESC;
