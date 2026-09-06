with source as (

    select * 
    from {{ source('sales', 'salesorderdetail') }}
)

, renamed as (

    select
        salesorderdetailid as sales_order_detail_id
        , salesorderid as sales_order_id
        , productid as product_id
        
        -- Métricas Quantitativas e Financeiras
        , orderqty as order_qty
        , unitprice as unit_price
        , unitpricediscount as unit_price_discount
    from source
)

select * 
from renamed