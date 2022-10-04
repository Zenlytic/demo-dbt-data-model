{{ config(materialized='table') }}

with source as (
    select * from {{ source('demo_raw', 'site_events') }}
)

select * from source 
