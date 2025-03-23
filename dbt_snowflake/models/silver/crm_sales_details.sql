{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT *
    FROM {{ source('bronze', 'CRM_SALES_DETAILS') }}
),
transformed_data AS (
    SELECT 
        sls_ord_num AS order_number,
        sls_prd_key AS product_key,
        sls_cust_id AS customer_id,

        CASE 
            WHEN sls_order_dt = 0 
                 OR LENGTH(sls_order_dt) != 8 
            THEN 
                -- Fallback: use ship_dt minus 2 days if order_dt is invalid
                DATEADD(day, -2, TO_DATE(sls_ship_dt::VARCHAR, 'YYYYMMDD'))
            ELSE 
                TO_DATE(sls_order_dt::VARCHAR, 'YYYYMMDD') 
        END AS order_date,

        CASE 
            WHEN sls_ship_dt = 0 
                 OR LENGTH(sls_ship_dt) != 8
            THEN NULL
            ELSE TO_DATE(sls_ship_dt::VARCHAR, 'YYYYMMDD')
        END AS ship_date,

        CASE 
            WHEN sls_due_dt = 0 
                 OR LENGTH(sls_due_dt) != 8
            THEN NULL
            ELSE TO_DATE(sls_due_dt::VARCHAR, 'YYYYMMDD')
        END AS due_date,

        CASE 
            WHEN sls_sales IS NULL 
                 OR sls_sales <= 0 
                 OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sales,

        sls_quantity AS quantity,

        CASE 
            WHEN sls_price IS NULL 
                 OR sls_price <= 0 
            THEN sls_sales / NULLIF(sls_quantity, 0)
            ELSE sls_price
        END AS price
    FROM raw_data
)

SELECT *
FROM transformed_data
