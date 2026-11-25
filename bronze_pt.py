# Databricks notebook source
# MAGIC %md
# MAGIC **STEP 1 : SETTING A DYANAMIC INCREMENTAL LOAD**

# COMMAND ----------

# DBTITLE 1,Incremental load date with empty-table fallback
if spark.catalog.tableExists("datamodeling_pratice.bronze.bronze_table"):
    last_load_date = spark.sql("SELECT max(order_date) FROM datamodeling_pratice.bronze.bronze_table").collect()[0][0]
    if last_load_date is None:
        last_load_date = '1900-01-01'
else:
    last_load_date = '1900-01-01'


# COMMAND ----------

print(last_load_date)

# COMMAND ----------

# MAGIC %md
# MAGIC **STEP 2 : CREATING A TEMP TABLE [staging layer] DATA FROM SOURCE**

# COMMAND ----------

spark.sql(f"""select * from datamodeling_pratice.default.source_data
where order_date > '{last_load_date}'""").createOrReplaceTempView('bronze_temp')

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from bronze_temp

# COMMAND ----------

# MAGIC %md
# MAGIC **STEP 3 : CREATE A ACTUAL BRONZE TABLE [ data from view ]**

# COMMAND ----------

# MAGIC %sql
# MAGIC create or replace table datamodeling_pratice.bronze.bronze_table
# MAGIC as
# MAGIC select * from bronze_temp

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from datamodeling_pratice.bronze.bronze_table