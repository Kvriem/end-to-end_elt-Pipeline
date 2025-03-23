{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT
        *
    FROM {{ source('bronze', 'ERP_PX_CAT_G1V2') }}
),

transformed_data AS (
    SELECT
         ID AS category_id,
        TRIM(CAT) AS category,
        TRIM(SUBCAT) AS subcategory,
       CASE 
          WHEN UPPER(MAINTENANCE) = 'YES' THEN TRUE
          ELSE FALSE
        END AS maintenance_required
    FROM raw_data
)

SELECT *
FROM transformed_data
