with source as (
    select * from {{ source('demo_raw', 'order_lines') }}
),

return_lines as (
    select * from {{ source('demo_raw', 'returns') }}
),

order_info as (
    select * from {{ source('demo_raw', 'order_info') }}
),

click_info as (
    select * from {{ source('demo_raw', 'click_info') }}
),

base as (
  select 
    row_number() over (partition by order_line_id order by order_at) as order_line_number,
    *
  from source
),

sub_result as (
    select 
        *,
        dense_rank() over (partition by customer_id order by order_at)      as order_number,
        case when order_number = 1 then 'New' else 'Repeat' end             as new_vs_repeat
    from base
    where order_line_number = 1
),

result as (
  select 
    sub_result.order_line_id,
    sub_result.order_id,
    sub_result.customer_id,
    sub_result.product_id,
    sub_result.order_at,
    sub_result.subscription_vs_otp,
    sub_result.marketing_channel,
    sub_result.marketing_source,
    sub_result.campaign,
    sub_result.promotion,
    sub_result.price,
    sub_result.quantity,
    sub_result.discount,
    sub_result.revenue,
    sub_result.revenue * 0.21 + sub_result.discount * 30 as cogs,
    sub_result.order_number, 
    sub_result.new_vs_repeat,
    order_info.ar_vr_viewed,
    order_info.product_video_viewed,
    order_info.live_chat_used,
    order_info.style_guide_viewed,
    click_info.first_click,
    click_info.last_click,
    return_lines.return_at is not null as is_returned,
    return_lines.return_at,
    return_lines.returned_for_fit
  from sub_result
    left join order_info 
      on order_info.order_id = sub_result.order_id
    left join click_info
      on click_info.order_line_id = sub_result.order_line_id
    left join return_lines
      on return_lines.order_line_id = sub_result.order_line_id
)

select * from result
