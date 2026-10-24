with product as (
    select * 
    from {{ ref('stg_production__product') }}
)

, subcategory as (
    select * 
    from {{ ref('stg_production__product_subcategory') }}
)

, category as (
    select * 
    from {{ ref('stg_production__product_category') }}
)

, int_product as (
    select
        product.product_id
        , product.product_name
        , product.product_number
        , product.color
        , product.list_price
        , product.product_subcategory_id
        , subcategory.product_subcategory_name
        , subcategory.product_category_id
        , category.product_category_name
    from product
    left join subcategory
        on product.product_subcategory_id = subcategory.product_subcategory_id
    left join category
        on subcategory.product_category_id = category.product_category_id
)

select * 
from int_product
