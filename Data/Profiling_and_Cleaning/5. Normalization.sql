/*******************************************************************************************
 STEP 5: CREATE CLEAN TABLES AND LOAD DATA
********************************************************************************************/

-- -------------------------------
-- 5.1: Country Lookup Table
-- -------------------------------
-- Contains standardized country codes and regions for reference.
CREATE TABLE country_lookup (
    country NVARCHAR(100) NULL,
    alpha_2 NVARCHAR(50) NOT NULL,      -- primary country code
    alpha_3 NVARCHAR(50) NOT NULL,
    country_code INT NOT NULL,
    region NVARCHAR(100) NULL,
    sub_region NVARCHAR(50) NULL,
    region_code INT NULL,
    sub_region_code INT NULL,
    CONSTRAINT PK_country_lookup PRIMARY KEY (alpha_2)
);

-- Load cleaned country data
INSERT INTO country_lookup
SELECT *
FROM country_lookup_staging
WHERE country IS NOT NULL;


/*-------------------------------
5.2: Products Table
-------------------------------*/
-- Stores unique products with IDs and names
CREATE TABLE products (
    product_id NVARCHAR(255) NOT NULL,
    product_name NVARCHAR(255) NOT NULL,
    CONSTRAINT PK_products PRIMARY KEY (product_id)
);

-- Load distinct products from staging
INSERT INTO products
SELECT DISTINCT
    product_id,
    product_name
FROM orders_staging
WHERE product_id IS NOT NULL;


/*-------------------------------
5.3: Orders Table
-------------------------------*/
-- Central table storing orders and relevant attributes
CREATE TABLE orders (
    customer_id NVARCHAR(255) NOT NULL,
    order_id NVARCHAR(255) NOT NULL,
    purchase_ts DATE NOT NULL,
    product_id NVARCHAR(255) NOT NULL,
    currency NVARCHAR(10) NOT NULL,
    local_price DECIMAL(10,2) NOT NULL,
    usd_price DECIMAL(10,2) NOT NULL,
    purchase_platform NVARCHAR(50) NULL,
    marketing_channel NVARCHAR(50) NULL,
    account_creation_method NVARCHAR(50) NOT NULL,
    loyalty_program NVARCHAR(50) NULL,
    country_code NVARCHAR(50) NOT NULL, -- matches alpha_2 in country_lookup
    ship_ts DATE NULL,
    delivery_ts DATE NULL,
    refund_ts DATE NULL,
    CONSTRAINT PK_orders PRIMARY KEY (order_id),
    CONSTRAINT FK_orders_products FOREIGN KEY (product_id) REFERENCES products(product_id),
    CONSTRAINT FK_orders_country FOREIGN KEY (country_code) REFERENCES country_lookup(alpha_2)
);

-- Load cleaned orders from staging
INSERT INTO orders
SELECT
    customer_id,
    order_id,
    purchase_ts,
    product_id,
    UPPER(currency) AS currency,  -- standardize currency
    local_price,
    usd_price,
    purchase_platform,
    marketing_channel,
    account_creation_method,
    loyalty_program,
    country_code,
    ship_ts,
    delivery_ts,
    refund_ts
FROM orders_staging o;


/*******************************************************************************************
 VALIDATION / SANITY CHECKS ON CLEAN TABLES
********************************************************************************************/

-- Count total rows inserted
SELECT COUNT(*) AS total_orders FROM orders;

-- Check for missing critical NOT NULL columns
SELECT COUNT(*) AS missing_critical_values
FROM orders
WHERE customer_id IS NULL
   OR order_id IS NULL
   OR purchase_ts IS NULL
   OR product_id IS NULL
   OR account_creation_method IS NULL
   OR country_code IS NULL;

-- Validate foreign key integrity
-- Check product_id references
SELECT DISTINCT product_id 
FROM orders
WHERE product_id NOT IN (SELECT product_id FROM products);

-- Check country_code references
SELECT DISTINCT country_code 
FROM orders
WHERE country_code NOT IN (SELECT alpha_2 FROM country_lookup);
