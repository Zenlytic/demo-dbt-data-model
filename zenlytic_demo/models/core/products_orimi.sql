with source as (
    select * from {{ source('demo_raw', 'products') }}
),

results as (
    select 
        product_id  as product_id,
        price       as price,
        case 
            when product_id in ('P1', 'P2', 'P3', 'P4') then 'Mens Loafers'
            when product_id in ('P5', 'P6') then 'Mens Boots'
            when product_id in ('P7', 'P8', 'P9') then 'Womens Pumps'
            when product_id in ('P10', 'P11', 'P12') then 'Womens Wedges'
        end         as product_type,
        case 
            when product_id = 'P1' then 'Edwin Loafer'
            when product_id = 'P2' then 'Cinque Loafer'
            when product_id = 'P3' then 'Amalfi Loafer'
            when product_id = 'P4' then 'Milan Loafer'
            when product_id = 'P5' then 'Florence Boot'
            when product_id = 'P6' then 'Mallorca Boot'
            when product_id = 'P7' then 'Annalisa Heel'
            when product_id = 'P8' then 'Livia Heel'
            when product_id = 'P9' then 'Yelena Pump'
            when product_id = 'P10' then 'Livia Sandal'
            when product_id = 'P11' then 'Isoble Wedge'
            when product_id = 'P12' then 'Helene Wedge'
        end         as product_title
    from source
)

select * from results
