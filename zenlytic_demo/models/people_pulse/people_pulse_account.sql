with source as (
    select * from {{ source('demo_raw', 'people_pulse_account') }}
)

select * from source 
