-- File: models/silver/crm_product_info.sql
{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT
        *
    FROM {{ source('bronze', 'CRM_PRD_INFO') }}
),

transformed_data AS (
    SELECT
        PRD_ID AS product_id,
        REPLACE(SUBSTR(prd_key, 1, 5), '-', '_') AS category_id,
        PRD_KEY AS product_key,
        TRIM(PRD_NM) AS product_name,
        CAST(PRD_COST AS DECIMAL(10,2)) AS product_cost,

        CASE 
            WHEN Trim(UPPER(PRD_LINE)) = 'R' THEN 'Road'
            WHEN Trim(UPPER(PRD_LINE)) = 'S' THEN 'Sport'
            WHEN Trim(UPPER(PRD_LINE)) = 'M' THEN 'Mountain'
            ELSE 'Other'
        END AS product_line,

        TO_DATE(PRD_START_DT) AS product_start_date,
        TO_DATE(PRD_END_DT)   AS product_end_date
    FROM raw_data
)

SELECT *
FROM transformed_data
