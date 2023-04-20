with source as (
    select * from {{ source('demo_raw', 'order_lines') }}
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
        revenue * 0.21 + discount * 30                                      as cogs,
        dense_rank() over (partition by customer_id order by order_at)      as order_number,
        case when order_number = 1 then 'New' else 'Repeat' end             as new_vs_repeat
    from base
    where order_line_number = 1
),

result as (
  select 
    sub_result.*,
    click_info.first_click,
    click_info.last_click
  from sub_result
    left join click_info
      on click_info.order_line_id = sub_result.order_line_id
)

select 
  order_line_id,
	order_id,
  customer_id,
  product_id,
  order_at,
  subscription_vs_otp,
  marketing_channel,
  marketing_source,
  cogs,
  first_click,
  last_click,
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result

union all 

select 
  order_line_id + 1134352342 as order_line_id,
	order_id  + 1134352342 as order_id,
  customer_id,
  product_id,
  dateadd('day', -146, order_at) as order_at,
  subscription_vs_otp,
  marketing_channel,
  marketing_source,
  cogs,
  first_click,
  last_click,
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result

union all 

select 
  order_line_id + 1134352342333 as order_line_id,
	order_id  + 1134352342333 as order_id,
  customer_id,
  product_id,
  dateadd('day', -146 * 2, order_at) as order_at,
  subscription_vs_otp,
  marketing_channel,
  marketing_source,
  cogs,
  first_click,
  last_click,
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result


union all 

select 
  order_line_id + 52342333 as order_line_id,
	order_id  + 52342333 as order_id,
  customer_id,
  product_id,
  dateadd('day', -146 * 3, order_at) as order_at,
  subscription_vs_otp,
  marketing_channel,
  marketing_source,
  cogs,
  first_click,
  last_click,
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result

union all 

select 
  order_line_id + 5234233355555 as order_line_id,
	order_id  + 5234233355555 as order_id,
  customer_id,
  product_id,
  dateadd('day', -146 * 4, order_at) as order_at,
  subscription_vs_otp,
  marketing_channel,
  marketing_source,
  cogs,
  first_click,
  last_click,
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result
