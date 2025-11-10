/*******************************************************************************************
 STEP 1: DATA PROFILING
********************************************************************************************
Data imported from: orders_data_raw.csv & country_lookup.csv  

• All columns initially allowed NULLs to avoid import errors and preserve raw data integrity.  
• Some columns (especially timestamps) imported as NVARCHAR to safely handle inconsistent formats.  
• Data types and constraints will be refined in later cleaning stages.
*******************************************************************************************/

-- Check total vs. unique order IDs (should match)
SELECT 
	COUNT(*) AS total_rows, 
	COUNT(DISTINCT order_id) AS unique_orders
FROM 
	orders_staging;

-- Count distinct customers
SELECT 
	COUNT(DISTINCT customer_id) AS total_customers
FROM 
	orders_staging;

-- Inspect categorical columns
SELECT DISTINCT purchase_platform FROM orders_staging ORDER BY 1;
SELECT DISTINCT marketing_channel FROM orders_staging ORDER BY 1;
SELECT DISTINCT account_creation_method FROM orders_staging ORDER BY 1;
SELECT DISTINCT loyalty_program FROM orders_staging ORDER BY 1;

-- Inspect currency values (check for inconsistent casing)
SELECT DISTINCT 
	currency 
FROM 
	orders_staging 
ORDER BY 
	1;

-- Review available country data from lookup table
SELECT DISTINCT 
	alpha_2, 
	country, 
	region 
FROM 
	country_lookup_staging
ORDER BY 
	region, country;

-- Review numeric ranges and date boundaries
SELECT 
	MIN(usd_price) AS min_usd_price,
	MAX(usd_price) AS max_usd_price,
	MIN(delivery_ts) AS earliest_delivery,
	MAX(delivery_ts) AS latest_delivery
FROM 
	orders_staging;