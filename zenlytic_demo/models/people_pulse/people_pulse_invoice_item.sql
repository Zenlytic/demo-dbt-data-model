with source as (
    select * from {{ source('demo_raw', 'people_pulse_invoice_items') }}
)

select * from source 
