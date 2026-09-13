with source as (

    select * 
    from {{ source('production', 'product') }}
)

, renamed as (

    select
        productid as product_id
        , name as product_name
        , productnumber as product_number
        , color as color
        , standardcost as standard_cost
        , listprice as list_price
        , productsubcategoryid as product_subcategory_id
        , productmodelid as product_model_id
    from source
)

select * 
from renamed