-- Databricks notebook source
select * from datamodeling_pratice.silver.silver_table

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **CREATING DIM TABLE**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### _creating dim customer_

-- COMMAND ----------

CREATE OR REPLACE TABLE datamodeling_pratice.gold.dim_customers
AS
WITH REM_DUP
(
SELECT 
DISTINCT(CUSTOMER_ID),CUSTOMER_NAME,CUSTOMER_EMAIL,CUSTOMER_NAME_UPPER
FROM datamodeling_pratice.silver.silver_table)

SELECT *,
row_number() OVER(order BY CUSTOMER_ID) as dim_cust_key
FROM REM_DUP

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### _creating dim products_

-- COMMAND ----------

CREATE OR REPLACE TABLE datamodeling_pratice.gold.dim_products
AS
WITH REM_DUP
(
SELECT 
DISTINCT(product_id),product_name,product_category
FROM datamodeling_pratice.silver.silver_table)

SELECT *,
row_number() OVER(order BY product_id) as dim_prod_key
FROM REM_DUP


-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### _creating dim payment_

-- COMMAND ----------

create or replace table datamodeling_pratice.gold.dim_payment
as
with rem_dup (
select 
distinct(payment_type)
from datamodeling_pratice.silver.silver_table
)
select *, 
row_number() over (order by payment_type) as dim_payment_key
from rem_dup

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### _creating dim region_

-- COMMAND ----------

create or replace table datamodeling_pratice.gold.dim_region
as
with rem_dup (
select 
distinct(country)
from datamodeling_pratice.silver.silver_table
)
select *, 
row_number() over (order by country) as dim_country_key
from rem_dup

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **DIM SALES TABLE**

-- COMMAND ----------

-- MAGIC %python
-- MAGIC spark.sql("select * from datamodeling_pratice.silver.silver_table").columns

-- COMMAND ----------

create or replace table datamodeling_pratice.gold.dim_sales
as
select
 row_number() over (order by order_id) as dim_sales_key,
 order_id,
 order_date,
 customer_id,
 customer_name,
 customer_email,
 product_id,
 product_name,
 product_category,
 quantity,
 unit_price,
 payment_type,
 country,
 last_updated,
 customer_name_upper,
 previous_data_load
 from datamodeling_pratice.silver.silver_table
 

-- COMMAND ----------

select * from datamodeling_pratice.gold.dim_sales

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **CREATING FACT TABLE**

-- COMMAND ----------

select 
sl.dim_sales_key,
c.dim_cust_key,
p.dim_prod_key,
pt.dim_payment_key,
r.dim_country_key,
s.quantity,
s.unit_price,
s.order_date,
s.last_updated

from datamodeling_pratice.silver.silver_table s

left join 
datamodeling_pratice.gold.dim_customers C on s.customer_id = c.CUSTOMER_ID

left join  
datamodeling_pratice.gold.dim_products p on s.product_id = p.product_id

left join 
datamodeling_pratice.gold.dim_region r on s.country = r.country

left join 
datamodeling_pratice.gold.dim_payment pt on s.payment_type = pt.payment_type

left join
datamodeling_pratice.gold.dim_sales sl on s.order_id = sl.order_id
