{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT
        *
    FROM {{ source('bronze', 'ERP_CUST_AZ12') }}
),

transformed_data AS (
    SELECT
        CASE 
            WHEN cid LIKE 'NAS%' THEN SUBSTR(cid, 4, LENGTH(cid))
            ELSE cid 
        END AS customer_id,
         BDATE AS birth_date,
        GEN AS gender
    FROM raw_data
)

SELECT *
FROM transformed_data
