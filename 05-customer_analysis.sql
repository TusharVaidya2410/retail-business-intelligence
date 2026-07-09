/*
===========================================================
BUSINESS QUESTION 21
Unique Customers
===========================================================
*/

SELECT

COUNT(DISTINCT customer_id) AS customer_ids,

COUNT(DISTINCT customer_unique_id) AS unique_customers

FROM customers;
/*
===========================================================
BUSINESS QUESTION 22
Repeat Customers using customer_unique_id
===========================================================
*/

WITH customer_orders AS
(
SELECT

c.customer_unique_id,

COUNT(o.order_id) total_orders

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY c.customer_unique_id
)

SELECT

CASE

WHEN total_orders=1
THEN 'One-Time'

ELSE 'Repeat'

END customer_type,

COUNT(*) customers

FROM customer_orders

GROUP BY customer_type;
/*
===========================================================
BUSINESS QUESTION 23
Top Repeat Customers
===========================================================
*/

SELECT

c.customer_unique_id,

COUNT(o.order_id) total_orders,

ROUND(SUM(p.payment_value),2) total_spent

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

GROUP BY c.customer_unique_id

ORDER BY total_orders DESC,total_spent DESC

LIMIT 20;
/*
===========================================================
BUSINESS QUESTION 24
Average Orders per Customer
===========================================================
*/

WITH customer_orders AS
(
SELECT

customer_unique_id,

COUNT(order_id) total_orders

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY customer_unique_id
)

SELECT

ROUND(

AVG(total_orders)

,2)

AS average_orders

FROM customer_orders;
/*
===========================================================
BUSINESS QUESTION 25
Customer Lifetime Value
===========================================================
*/

SELECT

ROUND(

SUM(payment_value)

/

COUNT(DISTINCT customer_unique_id)

,2)

AS customer_lifetime_value

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id;
/*
===========================================================
BUSINESS QUESTION 26
Top 1% Customers
===========================================================
*/

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
),

ranked AS
(
SELECT

*,

NTILE(100)

OVER(
ORDER BY revenue DESC
)

AS percentile

FROM customer_sales
)

SELECT

customer_unique_id,

ROUND(revenue,2),

percentile

FROM ranked

WHERE percentile=1

ORDER BY revenue DESC;
/*
===========================================================
BUSINESS QUESTION 27
Customer Spending Segments
===========================================================
*/

WITH customer_sales AS
(
SELECT

c.customer_unique_id,

SUM(p.payment_value) revenue

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

GROUP BY customer_segment

ORDER BY average_spending;
/*
===========================================================
BUSINESS QUESTION 28
Customer Order Distribution
===========================================================
*/

WITH customer_orders AS
(
SELECT

customer_unique_id,

COUNT(order_id) total_orders

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY customer_unique_id
)

SELECT

total_orders,

COUNT(*) customers

FROM customer_orders

GROUP BY total_orders

ORDER BY total_orders;
/*
===========================================================
BUSINESS QUESTION 29
States with Highest Repeat Customers
===========================================================
*/

WITH repeat_customers AS
(
SELECT

customer_unique_id,

customer_state,

COUNT(order_id) total_orders

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

GROUP BY

customer_unique_id,

customer_state

)

SELECT

customer_state,

COUNT(*) repeat_customers

FROM repeat_customers

WHERE total_orders>1

GROUP BY customer_state

ORDER BY repeat_customers DESC;
/*
===========================================================
BUSINESS QUESTION 30
RFM Metrics
===========================================================
*/

SELECT

c.customer_unique_id,

MAX(o.order_purchase_timestamp) AS last_purchase,

COUNT(o.order_id) AS frequency,

ROUND(SUM(p.payment_value),2) AS monetary

FROM customers c

JOIN orders o
ON c.customer_id=o.customer_id

JOIN payments p
ON o.order_id=p.order_id

GROUP BY c.customer_unique_id

ORDER BY monetary DESC;
/*
===========================================================
BUSINESS QUESTION 31
Fastest Delivery States
===========================================================
*/

/*
===========================================================
BUSINESS QUESTION 31
Fastest Delivery States
===========================================================
*/

SELECT

c.customer_state,

ROUND(
AVG(
EXTRACT(
EPOCH FROM (
o.order_delivered_customer_date -
o.order_purchase_timestamp
)
) / 86400
),2
) AS average_delivery_days,

COUNT(*) total_orders

FROM orders o

JOIN customers c
ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days

LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 32
Slowest Delivery States
===========================================================
*/

/*
===========================================================
BUSINESS QUESTION 32
Slowest Delivery States
===========================================================
*/

SELECT

c.customer_state,

ROUND(
AVG(
EXTRACT(
EPOCH FROM (
o.order_delivered_customer_date -
o.order_purchase_timestamp
)
) / 86400
),2
) AS average_delivery_days,

COUNT(*) total_orders

FROM orders o

JOIN customers c
ON o.customer_id = c.customer_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY c.customer_state

ORDER BY average_delivery_days DESC

LIMIT 10;
/*
===========================================================
BUSINESS QUESTION 33
Delivery Time vs Customer Rating
===========================================================
*/

/*
===========================================================
BUSINESS QUESTION 33
Delivery Time vs Review Rating
===========================================================
*/

SELECT

r.review_score,

ROUND(
AVG(
EXTRACT(
EPOCH FROM (
o.order_delivered_customer_date -
o.order_purchase_timestamp
)
) / 86400
),2
) AS average_delivery_days,

COUNT(*) reviews

FROM reviews r

JOIN orders o
ON r.order_id = o.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY r.review_score

ORDER BY r.review_score;
/*
===========================================================
BUSINESS QUESTION 34
Revenue by Weekday
===========================================================
*/

SELECT

TO_CHAR(
o.order_purchase_timestamp,
'Day'
) AS weekday,

ROUND(
SUM(p.payment_value),
2
) AS revenue,

COUNT(DISTINCT o.order_id) AS total_orders

FROM orders o

JOIN payments p
ON o.order_id = p.order_id

GROUP BY weekday

ORDER BY revenue DESC;
/*
===========================================================
BUSINESS QUESTION 35
Revenue by Hour
===========================================================
*/

SELECT

EXTRACT(
HOUR FROM o.order_purchase_timestamp
) AS purchase_hour,

ROUND(
SUM(p.payment_value),
2
) AS revenue,

COUNT(DISTINCT o.order_id) AS total_orders

FROM orders o

JOIN payments p
ON o.order_id = p.order_id

GROUP BY purchase_hour

ORDER BY purchase_hour;