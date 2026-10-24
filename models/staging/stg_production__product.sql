with source as (

    select * 
    from {{ source('production', 'product') }}
)

, renamed as (

    select
        cast(productid as int) as product_id
        , cast(name as varchar) as product_name
        , cast(productnumber as varchar) as product_number
        , cast(color as varchar) as color
        , cast(standardcost as numeric(18, 4)) as standard_cost
        , cast(listprice as numeric(18, 4)) as list_price
        , cast(productsubcategoryid as int) as product_subcategory_id
        , cast(productmodelid as int) as product_model_id
    from source
)

select * 
from renamed