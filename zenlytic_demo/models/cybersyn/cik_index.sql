with source as (
    select * from {{ source ('cybersyn', 'sec_cik_index') }}
)

select * from source
where cik in (select distinct cik from {{ ref('income_statement_metrics') }})
