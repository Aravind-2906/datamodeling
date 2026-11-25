-- Databricks notebook source
-- MAGIC %md
-- MAGIC ### **COLLECT DATA FROM BRONZE AND APPLY TRANSFORMATION**

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **and also creating silver temp table**

-- COMMAND ----------

-- MAGIC %python
-- MAGIC spark.sql(""" select *,
-- MAGIC upper(customer_name) as customer_name_upper,
-- MAGIC date(current_timestamp) as previous_data_load
-- MAGIC from datamodeling_pratice.bronze.bronze_table """).createOrReplaceTempView("silver_temp")

-- COMMAND ----------

select * from silver_temp

-- COMMAND ----------

-- MAGIC %md
-- MAGIC **CREATING A ACTUAL SILVER TABLE**

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS datamodeling_pratice.silver.silver_table
as 
SELECT * from silver_temp

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### **APPLY UPSERT AND MERGE BY USING SQL**

-- COMMAND ----------

-- DBTITLE 1,MERGE deduplicated silver_temp into silver_table
MERGE INTO datamodeling_pratice.silver.silver_table
USING silver_temp
ON datamodeling_pratice.silver.silver_table.order_id = silver_temp.order_id
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *

-- COMMAND ----------

select * from datamodeling_pratice.silver.silver_table