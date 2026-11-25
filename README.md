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
  * **On-Time vs. Late Rating Drop:** `[TBD — On-time avg rating vs. Late avg rating & overall % late]`
  * **Delay Tipping Point:** `[TBD — Exact delay_days threshold where review scores collapse]`
  * **Worst-Affected States:** `[TBD — Top states by late delivery % and lowest review score]`
* **Actionable Recommendations:**
  * `[TBD — Logistics & SLA adjustment recommendations based on findings]`

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
* `sql/02_business_questions_analysis.sql` — Analytical SQL queries answering Business Questions 1–3
