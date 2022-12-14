with source as (
    select * from {{ source('demo_raw', 'marketing_spend') }}
)

select * from source 
