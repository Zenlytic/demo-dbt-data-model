with source as (
    select * from {{ source('demo_raw', 'people_pulse_sales_rep') }}
)

select * from source 
