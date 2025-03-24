{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT
        *
    FROM {{ source('bronze', 'ERP_LOC_A101') }}
),

transformed_data AS (

    SELECT
        CID AS customer_id,
        case 
        when TRIM(cntry) = 'US' or TRIM(cntry) = 'United States' 
            then 'USA'
        else cntry
        end AS city_name
    FROM raw_data
)

SELECT *
FROM transformed_data
