with source as (

    select * 
    from {{ source('production', 'productcategory') }}
)

, renamed as (

    select
        cast(productcategoryid as int) as product_category_id
        , cast(name as varchar) as product_category_name
    from source
)

select * 
from renamed
