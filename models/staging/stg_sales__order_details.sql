with source as (

    select * 
    from {{ source('sales', 'salesorderdetail') }}
)

, renamed as (

    select
        cast(salesorderdetailid as int) as sales_order_detail_id
        , cast(salesorderid as int) as sales_order_id
        , cast(productid as int) as product_id
        
        -- Métricas Quantitativas e Financeiras
        , cast(orderqty as int) as order_qty
        , cast(unitprice as numeric(18, 4)) as unit_price
        , cast(unitpricediscount as numeric(18, 4)) as unit_price_discount
    from source
)

select * 
from renamed