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
    select 
      order_line_id, 
      max(first_click) as first_click,
      max(last_click) as last_click
    from {{ source('demo_raw', 'click_info') }}
    group by 1
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
    return_lines.returned_for_fit,
    case 
      when return_lines.return_at is not null then 
        case 
          when return_lines.returned_for_fit = true then 'Product description was inaccurate'
          when sub_result.marketing_channel = 'Paid Search' then 'Did not like the look'
          when sub_result.marketing_channel = 'Organic' then 'Not what I ordered'
          when sub_result.marketing_channel = 'Facebook' then 'Took to long to get to me'
          when sub_result.marketing_channel = 'TikTok' then 'Arrived damaged'
          else 'Other - Return'
        end
      else null
    end                               as return_reason
  from sub_result
    left join order_info 
      on order_info.order_id = sub_result.order_id
    left join click_info
      on click_info.order_line_id = sub_result.order_line_id
    left join return_lines
      on return_lines.order_line_id = sub_result.order_line_id
)

select * from result
