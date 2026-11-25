CREATE OR REPLACE VIEW `data-portfolio-515209.olist_ecommerce.vw_sales_logistics_master` AS
SELECT
  o.order_id, oi.order_item_id, c.customer_unique_id, o.order_status, o.order_purchase_timestamp,
  c.customer_state, c.customer_city, s.seller_state, p.product_category_name,
  oi.price, oi.freight_value, (oi.price + oi.freight_value) AS total_item_value,
  ore.review_score,
  TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) AS delivery_days,
  TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, DAY) AS delay_days,
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
    WHEN o.order_delivered_customer_date IS NOT NULL THEN 0
    ELSE NULL
  END AS is_late
FROM olist_ecommerce.orders AS o 
LEFT JOIN olist_ecommerce.order_items AS oi 
  ON o.order_id = oi.order_id
LEFT JOIN olist_ecommerce.products AS p 
  ON oi.product_id = p.product_id 
LEFT JOIN olist_ecommerce.customers AS c 
  ON o.customer_id = c.customer_id 
LEFT JOIN olist_ecommerce.sellers AS s 
  ON oi.seller_id = s.seller_id
LEFT JOIN olist_ecommerce.order_reviews AS ore 
  ON o.order_id = ore.order_id;
