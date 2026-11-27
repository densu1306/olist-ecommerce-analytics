-- ============================================================================
-- Business Question #1: Category Revenue, Volume & Shipping Cost Burden
-- Source View: vw_sales_logistics_master
-- ============================================================================

-- 1. Top Product Categories by Revenue, Order Volume & Shipping Cost Ratio
SELECT
    product_category_name_english AS category,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(order_item_id) AS total_items_sold,
    ROUND(SUM(price), 2) AS product_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(SUM(price + freight_value), 2) AS total_customer_spend,
    ROUND(SAFE_DIVIDE(SUM(freight_value), SUM(price + freight_value)) * 100, 2) AS freight_share_pct,
    ROUND(AVG(review_score), 2) AS avg_review_score
FROM `olist_ecommerce.vw_sales_logistics_master`
WHERE order_status = 'delivered'
  AND product_category_name_english IS NOT NULL
GROUP BY 1
ORDER BY product_revenue DESC;

-- 2. High-Volume "Shipping Margin Traps" (Categories with >= 1,000 items & highest freight burden)
SELECT
    product_category_name_english AS category,
    COUNT(order_item_id) AS total_items_sold,
    ROUND(SUM(price), 2) AS product_revenue,
    ROUND(SAFE_DIVIDE(SUM(freight_value), SUM(price + freight_value)) * 100, 2) AS freight_share_pct
FROM `olist_ecommerce.vw_sales_logistics_master`
WHERE order_status = 'delivered'
  AND product_category_name_english IS NOT NULL
GROUP BY 1
HAVING COUNT(order_item_id) >= 1000
ORDER BY freight_share_pct DESC;
