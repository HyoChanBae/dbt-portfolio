SELECT 
    order_id,
    customer_id,
    order_status,
    CAST(order_estimated_delivery_date AS DATETIME) AS estimated_delivery_date,
    CAST(order_delivered_customer_date AS DATETIME) AS actual_delivery_date,
    DATEDIFF(
        CAST(order_delivered_customer_date AS DATETIME),
        CAST(order_estimated_delivery_date AS DATETIME)
    ) AS delayed_days,
    CASE 
        WHEN CAST(order_delivered_customer_date AS DATETIME)
           > CAST(order_estimated_delivery_date AS DATETIME)
        THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status
FROM {{ source('brazil_ecommerce', 'orders') }}
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND TRIM(CAST(order_delivered_customer_date AS CHAR)) <> ''
  AND TRIM(CAST(order_estimated_delivery_date AS CHAR)) <> ''
ORDER BY delayed_days DESC
