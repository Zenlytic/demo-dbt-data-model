with source as (
    select * from {{ source('demo_raw', 'order_lines') }}
),

result as (
    select 
        *,
        dense_rank() over (partition by customer_id order by order_at)      as order_number,
        case when order_number = 1 then 'New' else 'Repeat' end             as new_vs_repeat
    from source 
)

select * from result
