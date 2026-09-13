with product as (
    select * 
    from {{ ref('stg_production__product') }}
)

, dim_product as (
    select
        product_id
        , product_name
        , product_number
        , color
        , list_price
    from product
)

select * 
from dim_product