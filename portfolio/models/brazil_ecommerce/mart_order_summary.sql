SELECT
    COUNT(order_id) AS total_orders
FROM {{ source('brazil_ecommerce', 'orders') }}
GROUP BY order_id
