/*******************************************************************************************
 STEP 3: DATA CLEANING
********************************************************************************************/

-- Issue 1. 
-- Fill missing product_name values using self-join reference on product_id
WITH product_names AS (
	SELECT
		product_id,
		MIN(product_name) AS product_name
	FROM 
		orders_staging
	WHERE 
		product_name IS NOT NULL
	GROUP BY 
		product_id
)
UPDATE f
SET f.product_name = p.product_name
FROM 
	orders_staging f
JOIN 
	product_names p
	ON f.product_id = p.product_id
WHERE 
	f.product_name IS NULL;

-- Create backup before removing duplicates
SELECT * 
INTO 
	orders_staging_backup
FROM 
	orders_staging;

-- Issue 2. 
-- Remove duplicate orders (preserve earliest purchase)
WITH duplicate_rank AS (
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY customer_id, order_id, product_name ORDER BY purchase_ts) AS row_num
	FROM 
		orders_staging
)
DELETE FROM 
	duplicate_rank
WHERE 
	row_num > 1;

-- Issue 3. 
-- Standardize currency values to uppercase
UPDATE orders_staging
SET currency = UPPER(currency);

-- Issue 4. 
-- Convert timestamp columns to proper DATE format
ALTER TABLE orders_staging ALTER COLUMN purchase_ts DATE;
ALTER TABLE orders_staging ALTER COLUMN ship_ts DATE;
ALTER TABLE orders_staging ALTER COLUMN delivery_ts DATE;
ALTER TABLE orders_staging ALTER COLUMN refund_ts DATE;

-- Issue 5. More In Normalization Stage
-- Drop Unused country_lookup columns
-- Prep columns for normalization stage

ALTER TABLE country_lookup_staging
DROP COLUMN iso_3166_2, intermediate_region, intermediate_region_code;

-- Issue 6. 
-- Fix Invalid Country Codes
UPDATE orders_staging
SET country_code = CASE 
    WHEN country_code = 'ZI' THEN 'ZW'   -- Zimbabwe
    WHEN country_code = 'UK' THEN 'GB'   -- United Kingdom
    WHEN country_code = 'UN' THEN 'US'   -- United States
    WHEN country_code = 'TU' THEN 'TR'   -- Turkey
    WHEN country_code = 'EQ' THEN 'GQ'   -- Equatorial Guinea
    ELSE country_code
END
WHERE country_code IN ('ZI', 'UK', 'UN', 'TU', 'EQ');

-- Issue 7.
-- Set Antartica Region to Antartica
UPDATE country_lookup_staging
SET region = 'Antarctica',
	sub_region = 'Antarctica'
WHERE
	country = 'Antarctica';

