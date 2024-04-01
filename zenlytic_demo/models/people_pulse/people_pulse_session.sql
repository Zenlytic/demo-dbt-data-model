with source as (
    select * from {{ source('demo_raw', 'people_pulse_sessions') }}
)

select * from source 
