/*
===========================================================
Retail Business Intelligence & Customer Analytics
Phase 2 : Data Quality Assessment
===========================================================
*/

SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL
SELECT 'category_translation', COUNT(*) FROM category_translation;
/*
===========================================================
2. Missing Value Analysis
===========================================================
*/

-- Products Table

SELECT
COUNT(*) AS total_products,
COUNT(*)-COUNT(product_category_name) AS category_nulls,
COUNT(*)-COUNT(product_weight_g) AS weight_nulls,
COUNT(*)-COUNT(product_length_cm) AS length_nulls,
COUNT(*)-COUNT(product_height_cm) AS height_nulls,
COUNT(*)-COUNT(product_width_cm) AS width_nulls
FROM products;


-- Customers Table

SELECT
COUNT(*)-COUNT(customer_city) AS city_nulls,
COUNT(*)-COUNT(customer_state) AS state_nulls
FROM customers;


-- Orders Table

SELECT
COUNT(*)-COUNT(order_approved_at) AS approved_nulls,
COUNT(*)-COUNT(order_delivered_carrier_date) AS carrier_nulls,
COUNT(*)-COUNT(order_delivered_customer_date) AS delivered_nulls
FROM orders;


-- Reviews Table

SELECT
COUNT(*)-COUNT(review_comment_title) AS title_nulls,
COUNT(*)-COUNT(review_comment_message) AS message_nulls
FROM reviews;
/*
===========================================================
3. Duplicate Record Check
===========================================================
*/

-- Customers

SELECT customer_id,COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*)>1;


-- Orders

SELECT order_id,COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;


-- Products

SELECT product_id,COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;


-- Reviews

SELECT review_id,COUNT(*)
FROM reviews
GROUP BY review_id
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC;
/*
===========================================================
4. Dataset Time Span
===========================================================
*/

SELECT
MIN(order_purchase_timestamp) AS first_order,
MAX(order_purchase_timestamp) AS last_order
FROM orders;
/*
===========================================================
5. Order Status Distribution
===========================================================
*/

SELECT
order_status,
COUNT(*) AS total_orders,
ROUND(
COUNT(*)*100.0/
(SELECT COUNT(*) FROM orders),2
) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;
/*
===========================================================
6. Customer Distribution by State
===========================================================
*/

SELECT
customer_state,
COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;