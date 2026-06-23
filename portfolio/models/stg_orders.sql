SELECT 
    -- 1. 날짜를 'YYYY-MM' 형식의 문자열로 변환하여 가독성 확보
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    -- 2. 해당 월의 총 주문 건수 집계
    COUNT(order_id) AS total_orders
FROM {{ source('brazil_ecommerce', 'orders') }}
WHERE 
    -- 취소 및 미결제 주문 제외 (정상 주문만)
    order_status NOT IN ('canceled', 'unavailable')
GROUP BY 
    -- 변환한 연월 기준으로 그룹핑
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY 
    -- 과거부터 최신 순으로 정렬
    order_month ASC
