/*
===========================================================
BUSINESS QUESTION 1
Overall Business Summary
===========================================================
*/

SELECT
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM sellers) AS total_sellers,
    (SELECT COUNT(*) FROM products) AS total_products;
/*
===========================================================
BUSINESS QUESTION 2
Total Revenue
===========================================================
*/

SELECT
ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;    

/*
===========================================================
BUSINESS QUESTION 3
Average Order Value
===========================================================
*/

SELECT
ROUND(AVG(payment_value),2) AS average_order_value
FROM payments;
/*
===========================================================
BUSINESS QUESTION 4
Monthly Revenue Trend
===========================================================
*/

SELECT

DATE_TRUNC('month',o.order_purchase_timestamp) AS month,

ROUND(SUM(p.payment_value),2) AS revenue,

COUNT(DISTINCT o.order_id) AS total_orders

FROM orders o

JOIN payments p
ON o.order_id=p.order_id

GROUP BY month

ORDER BY month;
/*
===========================================================
BUSINESS QUESTION 5
Revenue by Payment Method
===========================================================
*/

SELECT

payment_type,

COUNT(*) total_transactions,

ROUND(SUM(payment_value),2) revenue

FROM payments

GROUP BY payment_type

ORDER BY revenue DESC;
/*
===========================================================
BUSINESS QUESTION 6
Top Product Categories by Revenue
===========================================================
*/

SELECT
    ct.product_category_name_english AS category,
    ROUND(SUM(p.payment_value),2) AS revenue
FROM products pr
JOIN category_translation ct
    ON pr.product_category_name = ct.product_category_name
JOIN order_items oi
    ON pr.product_id = oi.product_id
JOIN payments p
    ON oi.order_id = p.order_id
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 7
Best Selling Categories
===========================================================
*/

SELECT
    ct.product_category_name_english,
    COUNT(*) AS products_sold
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
JOIN category_translation ct
    ON pr.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY products_sold DESC
LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 8
Top Sellers by Revenue
===========================================================
*/

SELECT
    oi.seller_id,
    ROUND(SUM(p.payment_value),2) AS revenue
FROM order_items oi
JOIN payments p
    ON oi.order_id = p.order_id
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 9
Average Delivery Time
===========================================================
*/

/*
===========================================================
BUSINESS QUESTION 9
Average Delivery Time (Days)
===========================================================
*/

SELECT
ROUND(
AVG(
EXTRACT(EPOCH FROM
(order_delivered_customer_date - order_purchase_timestamp)
)/86400
),2
) AS average_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;
/*
===========================================================
BUSINESS QUESTION 10
Highest Rated Sellers
===========================================================
*/

SELECT
    oi.seller_id,
    ROUND(AVG(r.review_score),2) AS avg_rating,
    COUNT(*) AS total_reviews
FROM order_items oi
JOIN reviews r
    ON oi.order_id = r.order_id
GROUP BY oi.seller_id
HAVING COUNT(*) >= 50
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 11
Repeat vs One-Time Customers
===========================================================
*/

SELECT
CASE
    WHEN total_orders = 1 THEN 'One-Time Customer'
    ELSE 'Repeat Customer'
END AS customer_type,
COUNT(*) AS customers
FROM
(
    SELECT
    customer_id,
    COUNT(*) AS total_orders
    FROM orders
    GROUP BY customer_id
) t
GROUP BY customer_type;
/*
===========================================================
BUSINESS QUESTION 12
Top Customers by Spending
===========================================================
*/

SELECT
o.customer_id,
ROUND(SUM(p.payment_value),2) AS total_spent,
COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o

JOIN payments p
ON o.order_id=p.order_id

GROUP BY o.customer_id

ORDER BY total_spent DESC

LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 13
Revenue by Customer State
===========================================================
*/

SELECT

c.customer_state,

ROUND(SUM(p.payment_value),2) AS revenue,

COUNT(DISTINCT o.order_id) AS total_orders

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

GROUP BY customer_state

ORDER BY revenue DESC;
/*
===========================================================
BUSINESS QUESTION 14
Average Revenue per Customer
===========================================================
*/

SELECT

ROUND(

SUM(payment_value)
/COUNT(DISTINCT customer_id)

,2) AS revenue_per_customer

FROM orders o

JOIN payments p
ON o.order_id=p.order_id;
/*
===========================================================
BUSINESS QUESTION 15
Monthly Revenue Growth
===========================================================
*/

WITH monthly_sales AS
(
SELECT

DATE_TRUNC('month',o.order_purchase_timestamp) AS month,

SUM(payment_value) revenue

FROM orders o

JOIN payments p
ON o.order_id=p.order_id

GROUP BY month
)

SELECT

month,

ROUND(revenue,2),

ROUND(
100*
(revenue-LAG(revenue) OVER(ORDER BY month))
/
LAG(revenue) OVER(ORDER BY month)
,2
) AS growth_percentage

FROM monthly_sales

ORDER BY month;