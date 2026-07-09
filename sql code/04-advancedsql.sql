/*
===========================================================
BUSINESS QUESTION 16
Top Products within Each Category
===========================================================
*/

WITH product_sales AS
(
SELECT

pr.product_category_name,

oi.product_id,

COUNT(*) products_sold

FROM order_items oi

JOIN products pr
ON oi.product_id=pr.product_id

GROUP BY
pr.product_category_name,
oi.product_id
)

SELECT *

FROM

(
SELECT

*,

ROW_NUMBER()

OVER(
PARTITION BY product_category_name
ORDER BY products_sold DESC
)

AS ranking

FROM product_sales

)t

WHERE ranking<=3;
/*
===========================================================
BUSINESS QUESTION 17
Seller Revenue Ranking
===========================================================
*/

WITH seller_sales AS
(
SELECT

seller_id,

SUM(payment_value) revenue

FROM order_items oi

JOIN payments p
ON oi.order_id=p.order_id

GROUP BY seller_id
)

SELECT

seller_id,

ROUND(revenue,2),

RANK()

OVER(
ORDER BY revenue DESC
)

AS seller_rank

FROM seller_sales;
/*
===========================================================
BUSINESS QUESTION 18
Dense Ranking
===========================================================
*/

WITH seller_sales AS
(
SELECT

seller_id,

SUM(payment_value) revenue

FROM order_items oi

JOIN payments p
ON oi.order_id=p.order_id

GROUP BY seller_id
)

SELECT

seller_id,

ROUND(revenue,2),

DENSE_RANK()

OVER(
ORDER BY revenue DESC
)

AS seller_rank

FROM seller_sales;
/*
===========================================================
BUSINESS QUESTION 19
Running Revenue
===========================================================
*/

/*
===========================================================
BUSINESS QUESTION 19
Running Revenue
===========================================================
*/

WITH monthly_sales AS
(
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(p.payment_value) AS revenue
    FROM orders o
    JOIN payments p
        ON o.order_id = p.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;
/*
===========================================================
BUSINESS QUESTION 20
Revenue Contribution by Category
===========================================================
*/

WITH category_sales AS
(
SELECT

ct.product_category_name_english category,

SUM(payment_value) revenue

FROM products pr

JOIN category_translation ct
ON pr.product_category_name=ct.product_category_name

JOIN order_items oi
ON pr.product_id=oi.product_id

JOIN payments p
ON oi.order_id=p.order_id

GROUP BY category
)

SELECT

category,

ROUND(revenue,2),

ROUND(

100*revenue/

SUM(revenue)

OVER()

,2)

AS contribution_percentage

FROM category_sales

ORDER BY revenue DESC;