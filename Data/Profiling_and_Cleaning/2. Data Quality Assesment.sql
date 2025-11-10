/*******************************************************************************************
 STEP 2: DATA QUALITY ASSESSMENT
********************************************************************************************
Issues Log:
1. ~2500 NULL values in product_name  
2. ~1200 duplicate order_ids  
3. Inconsistent currency casing (CAD vs cad)  
4. Date columns (delivery_ts, refund_ts, ship_ts) imported as NVARCHAR and require conversion  
5. Several columns (IDs, timestamps) should eventually be set to NOT NULL in cleaned tables
6. Invalid country code values ('ZI', 'UK', 'UN', 'TU', 'EQ')
7. Populate NULL Antartica Region

*******************************************************************************************/

-- Compare number of non-null entries vs. total rows
SELECT
    COUNT(*) AS total_rows,
    COUNT(product_id) AS product_id_not_null,
    COUNT(customer_id) AS customer_id_not_null,
    COUNT(order_id) AS order_id_not_null,
    COUNT(product_name) AS product_name_not_null
FROM 
	orders_staging;

-- Count missing date fields
SELECT 
    SUM(CASE WHEN purchase_ts IS NULL THEN 1 ELSE 0 END) AS missing_purchase,
    SUM(CASE WHEN ship_ts IS NULL THEN 1 ELSE 0 END) AS missing_ship,
    SUM(CASE WHEN delivery_ts IS NULL THEN 1 ELSE 0 END) AS missing_delivery
FROM 
	orders_staging;

-- Identify duplicate orders
SELECT
	order_id,
	COUNT(*) AS order_count
FROM 
	orders_staging
GROUP BY 
	order_id
HAVING COUNT(*) > 1;

-- Detect outliers in price data
SELECT
	order_id,
	product_name,
	usd_price
FROM 
	orders_staging
WHERE 
	usd_price < 0 OR usd_price >= 10000;

-- Identify date inconsistencies (delivery before shipping/purchase)
SELECT
    purchase_ts,
    ship_ts,
    delivery_ts
FROM 
	orders_staging
WHERE
    DATEDIFF(DAY, CONVERT(DATE, ship_ts), CONVERT(DATE, delivery_ts)) < 0
    OR CONVERT(DATE, delivery_ts) < CONVERT(DATE, purchase_ts);

-- Average shipping and delivery durations (sanity check)
SELECT 
    AVG(DATEDIFF(DAY, purchase_ts, ship_ts)) AS avg_ship_days,
    AVG(DATEDIFF(DAY, ship_ts, delivery_ts)) AS avg_delivery_days
FROM 
	orders_staging
WHERE 
	ship_ts IS NOT NULL AND delivery_ts IS NOT NULL;

-- Validate country_code integrity against lookup table
SELECT DISTINCT 
	o.country_code
FROM 
	orders_staging o
WHERE 
	o.country_code NOT IN (SELECT alpha_2 FROM country_lookup_staging);

-- Validate lookup completeness (no NULL or duplicate country codes)
SELECT 
	COUNT(*) AS total_rows,
	COUNT(DISTINCT alpha_2) AS unique_country_codes,
	SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS missing_regions
FROM 
	country_lookup_staging;