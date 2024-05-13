with source as (
    select * from {{ source ('cybersyn', 'sec_report_text_attributes') }}
)

select 
    cik,
    period_end_date,
    regexp_substr(value, '(Item\\s+1A\\.\\s+Risk\\s+Factors.*?)(Item\\s+1B\\.|Item\\s+1C\\.)', 1, 1, 'cs') as item_1a
from source
where variable_name = '10-K Filing Text'

