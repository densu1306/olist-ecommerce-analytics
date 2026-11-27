# 📦 Olist E-Commerce Supply Chain & Profit Engine

An end-to-end cloud analytics solution analyzing **99,441+ orders** across the Brazilian Olist e-commerce marketplace to uncover profit drivers, logistics bottlenecks, and customer retention opportunities.

---

## 🛠️ Tech Stack & Cloud Architecture (\$0 Stack)
* **Storage (Data Lake):** Google Drive (9 raw relational CSV files)
* **ETL & Data Engineering:** Python (`Pandas`, `pandas-gbq`) in Google Colab
* **Cloud Data Warehouse:** Google BigQuery Sandbox (8 normalized tables + 3 analytical SQL Views)
* **Business Intelligence:** Looker Studio (Live interactive 3-page dashboard)

```text
Kaggle Raw CSVs ─► Google Drive ─► Google Colab (Python ETL) ─► BigQuery (SQL Views) ─► Looker Studio
```

---

## 📊 Business Questions, Key Findings & Recommendations

### 1. Category Revenue & Shipping Cost Burden
* **Question:** Which product categories generate the highest revenue and order volume, and how heavily do shipping (`freight_value`) costs eat into total customer spend?
* **Key Findings:**
  * **Top Revenue Driver:** `health_beauty` leads all categories with **$1,233,131.72** in product revenue (9,465 items across 8,647 orders) while maintaining a low **12.67%** shipping cost ratio.
  * **Top Volume Driver:** `bed_bath_table` moves the highest item volume (**10,953 items** across 9,272 orders) generating **$1,023,434.76**, with a moderate **16.47%** shipping cost ratio.
  * **High-Volume Shipping Margin Traps:** Among high-volume categories (`2,000+` items), `electronics` (**22.76%** shipping ratio on 2,729 items) and `furniture_decor` (**19.13%** shipping ratio on 8,160 items) lose nearly 1 in every 5 customer dollars to freight costs.
* **Actionable Recommendations:**
  * Introduce **cart-minimum bundle incentives** in low-unit-price categories like `electronics` (~$56.81 avg item price) to increase average order value and dilute flat shipping fees.
  * Establish **regional fulfillment hubs** for bulky `furniture_decor` merchants to reduce cross-state freight costs.

---

### 2. Delivery Delays & Customer Satisfaction Impact *(In Progress)*
* **Question:** How severely do late deliveries (`delivered_date > estimated_date`) damage 1–5 star customer reviews, what is the delay tipping point, and which states are hit hardest?
* **Key Findings:**
  * **On-Time vs. Late Rating Drop:**  Among 95,831 reviewed delivered orders, 92.0% (88,170) arrived on time (mean: 4.29, median: 5.0), while 8.0% (7,661) arrived late (mean: 2.57, median: 2.0)—representing a 40% drop in mean satisfaction and a 60% drop in median score.
  * **Delay Tipping Point:**  Customer ratings drop below a 3.0 mean and median starting at 3 days past the estimated delivery date (`delay_days` >= 3), remaining suppressed up to 54 days (beyond which sample sizes drop below 5 orders per day and become statistically noisy). Notably, 65.5% of all late orders exceed this 2-day threshold.
  * **Volume-Weighted Regional Performance:**  Across all 27 states, late-delivery rates range from 2.88% to 23.93%. Remote states such as `Alagoas` (23.93% late), `Roraima`, and `Maranhão` record the lowest mean ratings (3.61–3.76), but together represent only 1.2% of total order volume. Meanwhile, `São Paulo (SP)` generates 42.2% of all orders with a 5.89% late rate (mean: 4.17, median: 5.0).
* **Actionable Recommendations:** Because overall satisfaction is high and late deliveries affect only 8% of orders, Olist should avoid heavy infrastructure investments and execute two low-cost operational fixes over a 1–2 year evaluation window:
  * Trigger a "Day 2 Early-Warning" Intervention: Flag orders that are 1–2 days past their estimated delivery date—right before the Day 3 rating cliff—and automatically send a proactive WhatsApp/email delay update paired with a 5%–10% next-order discount voucher. Even if 6% of total orders trigger this voucher over the next two years, maximum gross discount exposure is only 0.30%–0.60% of revenue while protecting review scores and encouraging repeat purchases.
  * Recalibrate Checkout Delivery Estimates (+2–3 Buffer Days): Add 2–3 buffer days to the estimated delivery calculation for remote states with >13% late-delivery rates (AL, MA, RR). Adjusting customer expectations upfront absorbs carrier transit variability without capital expenditure.
---

### 3. Seller Performance & Customer RFM Retention *(Upcoming)*
* **Question:** Which sellers underperform on cancellations and late deliveries, and how are buyers segmented by Recency, Frequency, and Monetary value (RFM)?
* **Key Findings:**
  * `[TBD — Repeat purchase rate % & RFM segment breakdown]`
* **Actionable Recommendations:**
  * `[TBD — Retention campaign for At-Risk VIPs & seller SLA enforcement]`

---

## 🧹 Data Cleaning & Relational Schema Highlights
* **Geolocation Deduplication:** Compressed ~1,000,163 raw coordinate rows into **19,015 unique zip-code centroids** (`avg lat/lng`), cutting storage overhead by ~98%.
* **Review Deduplication:** Verified multi-order review edge cases (`1 customer_unique_id` per `review_id` across split checkouts within 0–2s and repeat purchases) and deduplicated `order_reviews` to **1 latest review per `order_id`** to prevent join fan-out.
* **Category Translation:** Standardized Portuguese product categories into English and imputed missing labels as `unknown`.

---

## 📁 Repository Structure
* `notebooks/01_olist_etl_to_bigquery.ipynb` — Python data cleaning, auditing, and BigQuery ETL pipeline
* `sql/01_analytical_views.sql` — Production BigQuery Views (`vw_sales_logistics_master`, `vw_seller_scorecard`, `vw_customer_rfm`)
* `sql/02_category_revenue_freight.sql` — Analytical SQL queries answering Business Questions 1
* `sql/03_delivery_delay_impact.sql` — Analytical SQL queries answering Business Questions 2
