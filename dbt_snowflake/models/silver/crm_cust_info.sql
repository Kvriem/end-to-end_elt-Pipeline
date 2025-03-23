-- models/staging/crm_stg.sql
{{ config(
    materialized='table', 
    target_schema='silver'
) }}

WITH raw_data AS (
    SELECT *
    FROM {{ source('bronze', 'CRM_CUST_INFO') }}
),

transformed_data AS (
    SELECT
        cst_id AS customer_id,
        cst_key AS customer_key,
        TRIM(cst_firstname) AS first_name,
        TRIM(cst_lastname)  AS last_name,
        CASE 
            WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
            WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
            WHEN UPPER(cst_marital_status) = 'D' THEN 'Divorced'
        END AS marital_status,
        CASE 
            WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
            WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        END AS gender,
        TO_CHAR(cst_create_date, 'YYYY-MM-DD') AS customer_create_date
    FROM raw_data
)

SELECT *
FROM transformed_data
