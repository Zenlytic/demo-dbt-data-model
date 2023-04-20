with source as (
    select * from {{ source('demo_raw', 'products') }}
),

results as (
    select 
        product_id  as product_id,
        price       as price,
        case 
            when product_id in ('P1', 'P2', 'P3', 'P4') then 'Womens Dresswear'
            when product_id in ('P5', 'P6') then 'Mens Footwear'
            when product_id in ('P7', 'P8', 'P9') then 'Womens Blouses'
            when product_id in ('P10', 'P11', 'P12') then 'Womens Longs'
        end         as product_type,
        case 
            when product_id = 'P1' then 'Edwina Dress'
            when product_id = 'P2' then 'Giulia Dress'
            when product_id = 'P3' then 'Amalfi Dress'
            when product_id = 'P4' then 'Katarina Dress'
            when product_id = 'P5' then 'Florence low'
            when product_id = 'P6' then 'Mallorca high'
            when product_id = 'P7' then 'Annalisa Shirt'
            when product_id = 'P8' then 'Livia Shirt'
            when product_id = 'P9' then 'Yelena Shirt'
            when product_id = 'P10' then 'Livia Pant'
            when product_id = 'P11' then 'Isoble Pant'
            when product_id = 'P12' then 'Helene Pant'
        end         as product_title
    from source
)

select * from results
