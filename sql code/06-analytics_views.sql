/*
===========================================================
ANALYTICS VIEW 1
Executive KPI Summary
===========================================================
*/

CREATE OR REPLACE VIEW vw_executive_summary AS

SELECT
    (SELECT COUNT(*) FROM orders) AS total_orders,

    (SELECT COUNT(DISTINCT customer_unique_id)
     FROM customers) AS total_customers,

    (SELECT COUNT(*) FROM products) AS total_products,

    (SELECT COUNT(*) FROM sellers) AS total_sellers,

    (SELECT ROUND(SUM(payment_value),2)
     FROM payments) AS total_revenue,

    (
        SELECT ROUND(AVG(order_total),2)
        FROM (
            SELECT
                order_id,
                SUM(payment_value) AS order_total
            FROM payments
            GROUP BY order_id
        ) t
    ) AS average_order_value;
	SELECT * FROM vw_executive_summary;
/*
===========================================================
ANALYTICS VIEW 2
Monthly Sales
===========================================================
*/

CREATE OR REPLACE VIEW vw_monthly_sales AS

SELECT

DATE_TRUNC('month',o.order_purchase_timestamp) AS month,

COUNT(DISTINCT o.order_id) AS total_orders,

ROUND(SUM(p.payment_value),2) AS revenue

FROM orders o

JOIN payments p
ON o.order_id=p.order_id

GROUP BY month

ORDER BY month;
SELECT * FROM vw_monthly_sales;
/*
===========================================================
ANALYTICS VIEW 3
Category Performance
===========================================================
*/

CREATE OR REPLACE VIEW vw_category_performance AS

SELECT

ct.product_category_name_english AS category,

COUNT(oi.order_item_id) AS products_sold,

ROUND(SUM(p.payment_value),2) AS revenue

FROM products pr

JOIN category_translation ct
ON pr.product_category_name=ct.product_category_name

JOIN order_items oi
ON pr.product_id=oi.product_id

JOIN payments p
ON oi.order_id=p.order_id

GROUP BY category

ORDER BY revenue DESC;
/*
===========================================================
ANALYTICS VIEW 4
State Performance
===========================================================
*/

CREATE OR REPLACE VIEW vw_state_performance AS

SELECT

c.customer_state,

COUNT(DISTINCT o.order_id) total_orders,

ROUND(SUM(p.payment_value),2) revenue,

ROUND(

AVG(
EXTRACT(EPOCH FROM
(o.order_delivered_customer_date-o.order_purchase_timestamp)
)/86400
),2)

AS average_delivery_days

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY revenue DESC;
/*
===========================================================
ANALYTICS VIEW 5
Payment Analysis
===========================================================
*/

CREATE OR REPLACE VIEW vw_payment_analysis AS

SELECT

payment_type,

COUNT(*) transactions,

ROUND(SUM(payment_value),2) revenue,

ROUND(AVG(payment_value),2) average_payment

FROM payments

GROUP BY payment_type;
/*
===========================================================
ANALYTICS VIEW 6
Customer Segments
===========================================================
*/

CREATE OR REPLACE VIEW vw_customer_segments AS

WITH customer_sales AS
(
SELECT

c.customer_unique_id,

SUM(payment_value) revenue

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

GROUP BY c.customer_unique_id
)

SELECT

CASE

WHEN revenue<100 THEN 'Low Value'

WHEN revenue BETWEEN 100 AND 500 THEN 'Medium Value'

WHEN revenue BETWEEN 500 AND 1000 THEN 'High Value'

ELSE 'Premium'

END customer_segment,

COUNT(*) customers,

ROUND(AVG(revenue),2) average_spending

FROM customer_sales

GROUP BY customer_segment;
SELECT table_name

FROM information_schema.views

WHERE table_schema='public';