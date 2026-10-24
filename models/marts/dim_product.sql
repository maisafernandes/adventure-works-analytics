with product as (
    select * 
    from {{ ref('int_product') }}
)

, dim_product as (
    select
        product_id
        , product_name
        , product_number
        , color
        , list_price
        , product_subcategory_name
        , product_category_name
    from product
)

select * 
from dim_product
