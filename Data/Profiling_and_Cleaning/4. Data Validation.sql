/*******************************************************************************************
 STEP 4: VALIDATION / SANITY CHECKS
********************************************************************************************/

-- 1. Ensure all duplicates were removed
SELECT 
	order_id, 
	COUNT(*) 
FROM 
	orders_staging
GROUP 
	BY order_id
HAVING COUNT(*) > 1;

-- 2. Confirm no NULL product names remain
SELECT 
	COUNT(*) AS missing_product_names
FROM 
	orders_staging
WHERE 
	product_name IS NULL;

-- 3. Check for valid price values
SELECT 
	COUNT(*) AS invalid_prices
FROM 
	orders_staging
WHERE 
	usd_price < 0 OR usd_price >= 10000;

-- 4. Verify chronological order of timestamps
SELECT 
	COUNT(*) AS invalid_date_sequences
FROM 
	orders_staging
WHERE 
	delivery_ts < purchase_ts OR delivery_ts < ship_ts;

-- 5. Confirm all country_codes exist in lookup table
SELECT 
	COUNT(*) AS invalid_country_codes
FROM 
	orders_staging o
WHERE 
	o.country_code NOT IN (SELECT alpha_2 FROM country_lookup_staging);

-- 6. Check country_lookup completeness
SELECT 
	COUNT(DISTINCT alpha_2) AS total_country_codes,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS missing_country_names,
	SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS missing_regions
FROM 
	country_lookup_staging;

-- 7. Spot-check cleaned records
SELECT TOP 10 *
FROM 
	orders_staging
ORDER BY 
	purchase_ts DESC;

-- 8. Ensure categorical columns are standardized
SELECT DISTINCT 
	currency 
FROM 
	orders_staging 
ORDER BY 
	1;