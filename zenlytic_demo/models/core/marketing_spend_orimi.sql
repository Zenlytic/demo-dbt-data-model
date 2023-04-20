with source as (
    select * from {{ source('demo_raw', 'marketing_spend') }}
),

result as (
    select 
        spend_id        as spend_id,
        spend_at        as spend_at,
        channel         as channel,
        source          as source,
        campaign        as campaign,
        ad_spend * 10   as ad_spend
    from source 
)

select * from result
