{{
    config(
        materialized='view',
        target_schema='gold'
    )
}}

with Dim_customer as(
    SELECT 
        DISTINCT cust.customer_id AS customer_id,
        cust.customer_key AS customer_unique_key,
        cust.first_name,
        cust.last_name,
        CASE 
            WHEN cust.gender ='n/a' THEN erp.gender
            ELSE cust.gender
        END AS gender,
        erp.birth_date,
        loc.city_name 
    FROM {{ref("crm_cust_info")}} AS cust
    LEFT JOIN {{ref("erp_cust_az12")}} AS erp 
        ON cust.customer_key = erp.customer_id
    LEFT JOIN {{ref("erp_loc_a101")}}  AS loc 
        ON cust.customer_key = loc.customer_id
)
select * from Dim_customer 