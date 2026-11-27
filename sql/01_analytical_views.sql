# 1 Create view for sales logistics analysis
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

# 2. Create view for seller score card analysis
CREATE OR REPLACE VIEW `data-portfolio-515209.olist_ecommerce.vw_seller_scorecard` AS
SELECT
  s.seller_id, s.seller_state,
  oi.order_id, oi.price, oi.freight_value,
  ore.review_score,
  o.order_status,
  TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) AS delivery_days,
  TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date, DAY) AS delay_days,
  CASE
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1
    WHEN o.order_delivered_customer_date IS NOT NULL THEN 0
    ELSE NULL
  END AS is_late
FROM olist_ecommerce.sellers AS s
LEFT JOIN olist_ecommerce.order_items AS oi
  ON oi.seller_id = s.seller_id
LEFT JOIN olist_ecommerce.order_reviews AS ore
  ON ore.order_id = oi.order_id
LEFT JOIN olist_ecommerce.orders AS o
  ON o.order_id = oi.order_id;

# 3. Create view for customer rfm analysis
CREATE OR REPLACE VIEW `data-portfolio-515209.olist_ecommerce.vw_customer_rfm` AS 
SELECT
  c.customer_unique_id, c.customer_state,
  o.order_id, o.order_status,o.order_purchase_timestamp,
  oi.price, oi.freight_value, (oi.price + oi.freight_value) AS total_spend,
  TIMESTAMP_DIFF(
    TIMESTAMP_ADD(MAX(o.order_purchase_timestamp) OVER(), INTERVAL 1 DAY),
    o.order_purchase_timestamp,
    DAY
  ) AS days_since_last_purchase
FROM olist_ecommerce.customers AS c 
LEFT JOIN olist_ecommerce.orders AS o 
  ON o.customer_id = c.customer_id
LEFT JOIN olist_ecommerce.order_items AS oi 
  ON oi.order_id = o.order_id;
