# Retail Sales Data Modeling & Pipeline (Databricks)

An end-to-end data pipeline implementing the **Medallion Architecture** dimensional modeling in Databricks.

## Architecture Overview
- **Bronze Layer (`bronze_pt`):** Incremental ingestion of raw transaction logs using dynamic date watermarks.
- **Silver Layer (`silver_pt`):** Cleansing, deduplication, schema validation, and standardized transformations.
- **Gold Layer (`gold_pt`):** Dimensional model (Star Schema) built for downstream business intelligence and analytics.

## Dimensional Model Design
- **Fact Table:** `fact_sales` (metrics: `quantity`, `unit_price`, `order_date`, `last_updated`)
- **Dimension Tables:**
  - `dim_customers` (Customer profiles + surrogate key `dim_cust_key`)
  - `dim_products` (Product details & categories + surrogate key `dim_prod_key`)
  - `dim_payment` (Payment methods + surrogate key `dim_payment_key`)
  - `dim_region` (Geographic hierarchy + surrogate key `dim_country_key`)

## Tech Stack
- **Platform:** Databricks Community Edition
- **Storage:** Delta Lake
- **Languages:** SQL, Python / PySpark
