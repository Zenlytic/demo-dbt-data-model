with number_spine as (
	select
	row_number() over (order by null) as number
	from table(generator(rowcount => 12*10))
),

date_spine as (
	select 
	dateadd(
		month,
		number - 1,
		cast('2016-01-01' as date)
		) as date_month
	from number_spine
),

result as (
	select 
		order_lines.customer_id, 
		date_month, 
		count(distinct case when date_trunc(month, order_at)::date = date_month::date then customer_id end) as n_customers_in_month,
		count(distinct case when date_trunc(month, order_at)::date = date_month::date then order_id end) as n_orders_in_month,
		count(distinct order_id) as n_cumulative_orders,
		sum(revenue) as gross_sales
	from date_spine cross join {{ ref('order_lines') }} order_lines
	where date_trunc(month, order_at)::date <= date_month::date and date_month <= date_trunc(month, current_date)
	group by 1,2
)

select * from result
