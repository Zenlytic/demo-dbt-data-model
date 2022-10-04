{{ config(materialized='table') }}

with source as (
    select * from {{ source('demo_raw', 'products') }}
)

select * from source 
