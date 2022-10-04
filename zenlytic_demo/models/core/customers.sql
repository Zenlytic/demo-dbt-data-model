with source as (
    select * from {{ source('demo_raw', 'customers') }}
),

first_orders as (
    select 
        customer_id,
        min(order_at) as first_order_at,
        
        -- These work only because of the filter for the first orders only
        min(product_id) as first_product_id,
        min(marketing_channel) as first_channel,
        min(promotion) as first_promotion,
        min(campaign) as first_campaign

    from {{ ref('order_lines') }}
    where order_number = 1
    group by 1
),

result as (
    select 
        source.*,
        first_orders.first_order_at,
        first_orders.first_product_id,
        first_orders.first_channel,
        first_orders.first_promotion,
        first_orders.first_campaign
    from source 
        left join first_orders using (customer_id)
)

select * from result
