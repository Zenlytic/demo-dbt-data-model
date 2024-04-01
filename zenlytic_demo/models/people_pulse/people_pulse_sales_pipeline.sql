with source as (
    select * from {{ source('demo_raw', 'people_pulse_sales_pipeline') }}
)

select * from source 
