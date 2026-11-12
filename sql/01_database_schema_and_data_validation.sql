CREATE DATABASE olist_ecommerce;
SHOW DATABASES;
USE olist_ecommerce;
show tables;
select * from orders limit 5;
describe orders;
select count(*) from orders;
select * from orders;
SHOW CREATE TABLE orders;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
TRUNCATE TABLE orders;
show tables;
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);
select count(*) from orders;
select * from orders limit 5;
describe orders;
ALTER TABLE orders
MODIFY COLUMN order_purchase_timestamp DATETIME;
ALTER TABLE orders
MODIFY COLUMN order_approved_at DATETIME,
MODIFY COLUMN order_delivered_carrier_date DATETIME,
MODIFY COLUMN order_delivered_customer_date DATETIME,
MODIFY COLUMN order_estimated_delivery_date DATETIME;
SELECT
    COUNT(*) AS total_rows,
    SUM(order_approved_at = '') AS empty_approval_dates,
    SUM(order_delivered_carrier_date = '') AS empty_carrier_dates,
    SUM(order_delivered_customer_date = '') AS empty_delivery_dates
FROM orders;
SELECT COUNT(*)
FROM orders
WHERE order_approved_at IS NOT NULL;
SELECT COUNT(*)
FROM orders
WHERE order_approved_at IS NULL;
CREATE TABLE orders_staging (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);
DESCRIBE orders_staging;
ALTER TABLE orders
MODIFY COLUMN order_purchase_timestamp TEXT;
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
);
UPDATE orders
SET
    order_approved_at = NULLIF(order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(order_estimated_delivery_date, '');
set SQL_SAFE_UPDATES=0;
describe orders;
SELECT
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approved_dates,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_dates,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_dates
FROM orders;
CREATE TABLE customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
);
select count(*) from customers;
CREATE TABLE order_items (
    order_id TEXT,
    order_item_id INT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
);
select count(*) from order_items;
CREATE TABLE payments (
    order_id TEXT,
    payment_sequential INT,
    payment_type TEXT,
    payment_installments INT,
    payment_value DECIMAL(10,2)
);
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);
select count(*) from payments;
CREATE TABLE reviews (
    review_id TEXT,
    order_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);
truncate table reviews;
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_order_reviews_dataset.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);
show warnings;
SELECT *
FROM reviews
WHERE review_id = '1430053cd120f951ec234db3ded49571';
select count(*) from reviews;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_reviews
FROM reviews;
CREATE TABLE products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
CREATE TABLE sellers (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);
CREATE TABLE product_category_translation (
    product_category_name TEXT,
    product_category_name_english TEXT
);
show tables;
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
);
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);
LOAD DATA LOCAL INFILE
'C:/Users/SHANAVAZ/OneDrive/Desktop/Documents/GitHub/ecommerce-customer-intelligence/data/product_category_name_translation.csv'
INTO TABLE product_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);
SELECT 'products' AS table_name, COUNT(*) AS total_rows FROM products

UNION ALL

SELECT 'sellers', COUNT(*) FROM sellers

UNION ALL

SELECT 'product_category_translation', COUNT(*) 
FROM product_category_translation;
SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 10;
SELECT COUNT(*) AS unmatched_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
SELECT
    order_id,
    COUNT(*) AS total_items
FROM order_items
GROUP BY order_id
ORDER BY total_items DESC
LIMIT 10;
SELECT COUNT(*) AS unmatched_order_items
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;
SELECT
    order_id,
    COUNT(*) AS payment_records,
    SUM(payment_value) AS total_paid
FROM payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY payment_records DESC
LIMIT 10;
SELECT COUNT(*) AS unmatched_payments
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;
SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_sellers
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
SELECT COUNT(DISTINCT p.product_category_name) AS unmatched_categories
FROM products p
LEFT JOIN product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;


