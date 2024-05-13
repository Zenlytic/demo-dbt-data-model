with source as (
    select * from {{ source ('cybersyn', 'sec_report_attributes') }}
),

metrics as (
    select 
        cik,
        adsh,
        period_start_date,
        period_end_date,
        max(case when tag in ('RevenueFromContractWithCustomerExcludingAssessedTax', 'Revenues') then to_numeric(VALUE) else 0 end) as net_sales,
        max(case when tag in ('OperatingIncomeLoss') then to_numeric(VALUE) else 0 end) as operating_income,
        max(case when tag in ('NetIncomeLoss') then to_numeric(VALUE) else 0 end) as net_income,
        max(case when tag in ('EarningsPerShareDiluted') then to_numeric(VALUE) else 0 end) as eps_diulted,
        max(case when tag in ('EarningsPerShareBasic') then to_numeric(VALUE) else 0 end) as eps_basic
    from source
    where statement = 'Income Statement'
        and covered_qtrs = 4
        and metadata is null
    group by 1,2,3,4
)

select 
    * 
from metrics
where net_sales <> 0
    and operating_income <> 0
    and net_income <> 0
    and eps_basic <> 0
