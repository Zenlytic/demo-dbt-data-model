with source as (
    select * from {{ source('demo_raw', 'people_pulse_marketing_spend') }}
)

select * from source 
