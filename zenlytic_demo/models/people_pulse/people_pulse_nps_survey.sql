with source as (
    select * from {{ source('demo_raw', 'people_pulse_customer_nps_surveys') }}
)

select * from source 
