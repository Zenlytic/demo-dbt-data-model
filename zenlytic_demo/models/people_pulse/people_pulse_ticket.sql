with source as (
    select * from {{ source('demo_raw', 'people_pulse_tickets') }}
)

select * from source 
