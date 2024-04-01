with source as (
    select * from {{ source('demo_raw', 'people_pulse_plan') }}
)

select * from source 
