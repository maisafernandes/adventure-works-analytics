with product as (
    select * 
    from {{ ref('int_product') }}
)

, dim_product as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_sk
        , product_id
        , product_name
        , product_number
        , color
        , list_price
        , coalesce(product_subcategory_name, 'Sem subcategoria') as product_subcategory_name
        , coalesce(product_category_name, 'Sem categoria') as product_category_name
    from product
)

select * 
from dim_product
