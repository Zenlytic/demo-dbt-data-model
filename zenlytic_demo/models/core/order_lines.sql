with source as (
    select * from {{ source('demo_raw', 'order_lines') }}
),

base as (
  select 
    row_number() over (partition by order_line_id order by order_at) as order_line_number,
    *
  from source
),

result as (
    select 
        *,
        case 
          when product_id in ('P6', 'P8') then 0.3 * revenue
          else 0.25 * revenue
        end                                                                 as cogs,
        dense_rank() over (partition by customer_id order by order_at)      as order_number,
        case when order_number = 1 then 'New' else 'Repeat' end             as new_vs_repeat
    from base
    where order_line_number = 1
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
  campaign,
  promotion,
  price,
  quantity,
  discount,
  revenue,
  order_number, 
  new_vs_repeat
from result