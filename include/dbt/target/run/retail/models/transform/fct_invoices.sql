
  
    

    create or replace table `ecommerce-airflow`.`retail`.`fct_invoices`
    
    

    OPTIONS()
    as (
      WITH fct_invoices_cte AS (
    SELECT
        InvoiceNo AS invoice_id,
        InvoiceDate AS datetime_id,
        to_hex(md5(cast(coalesce(cast(StockCode as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(Description as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(UnitPrice as STRING), '_dbt_utils_surrogate_key_null_') as STRING))) as product_id,
        to_hex(md5(cast(coalesce(cast(CustomerID as STRING), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(Country as STRING), '_dbt_utils_surrogate_key_null_') as STRING))) as customer_id,
        Quantity AS quantity,
        Quantity * UnitPrice AS total
    FROM `ecommerce-airflow`.`retail`.`raw_invoices`
    WHERE Quantity > 0
)
SELECT
    invoice_id,
    dt.datetime_id,
    dp.product_id,
    dc.customer_id,
    quantity,
    total
FROM fct_invoices_cte fi
INNER JOIN `ecommerce-airflow`.`retail`.`dim_datetime` dt ON fi.datetime_id = dt.datetime_id
INNER JOIN `ecommerce-airflow`.`retail`.`dim_product` dp ON fi.product_id = dp.product_id
INNER JOIN `ecommerce-airflow`.`retail`.`dim_customer` dc ON fi.customer_id = dc.customer_id
    );
  