# CREATE TEMP TABLE FOR ORDER DELAYS ANALYTICS
CREATE TEMP TABLE order_delays AS
SELECT
  order_id, review_score, is_late, delay_days, customer_state
FROM olist_ecommerce.vw_sales_logistics_master 
GROUP BY order_id, review_score, is_late, delay_days, customer_state;

# 1. On-Time vs Late Rating Drop 
SELECT
  is_late,
  COUNT(order_id) AS total_order,
  ROUND(COUNTIF(review_score IS NULL)/COUNT(order_id)*100, 2) AS missing_reviews_pct,
  ROUND(AVG(review_score), 2) AS mean_review_score,
  ROUND(APPROX_QUANTILES(review_score, 2)[OFFSET(1)], 2) AS median_review_score,
  ROUND(AVG(delay_days), 2) AS mean_delay_days,
  ROUND(APPROX_QUANTILES(delay_days, 2)[OFFSET(1)], 2) AS median_delay_days
FROM order_delays
GROUP BY is_late;

# 2.The Delay Tipping Point
SELECT
  delay_days,
  COUNT(order_id) AS total_order,
  ROUND(COUNTIF(review_score IS NULL)/COUNT(order_id)*100, 2) AS missing_reviews_pct,
  ROUND(AVG(review_score), 2) AS mean_review_score,
  ROUND(APPROX_QUANTILES(review_score, 2)[OFFSET(1)], 2) AS median_review_score
FROM order_delays
WHERE is_late = 1
GROUP BY delay_days
ORDER BY delay_days ASC;

# 3.Regional Bottlenecks
SELECT
  customer_state,
  COUNT(order_id) AS total_order,
  ROUND(COUNTIF(is_late IS NULL)/COUNT(order_id)*100, 2) AS unknown_time_order_pct,
  ROUND(COUNTIF(review_score IS NULL)/COUNT(order_id)*100, 2) AS missing_reviews_pct,
  ROUND(COUNTIF(is_late = 1)/COUNT(is_late)*100, 2) AS delay_order_pct,
  ROUND(AVG(review_score), 2) AS mean_review_score,
  ROUND(APPROX_QUANTILES(review_score, 2)[OFFSET(1)], 2) AS median_review_score
FROM order_delays
GROUP BY customer_state
ORDER BY delay_order_pct DESC;
