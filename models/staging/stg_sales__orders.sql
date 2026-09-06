with source as (

    select * 
    from {{ source('sales', 'salesorderheader') }}
)

, renamed as (

    select
        salesorderid as sales_order_id
        , customerid as customer_id
        , territoryid as territory_id
        , creditcardid as credit_card_id

        -- Datas e Status
        , orderdate as order_date
        , status as order_status

        -- Métricas / Valores financeiros brutos
        , subtotal as sub_total
        , taxamt as tax_amount
        , freight as freight
        , totaldue as total_due
    from source
)

select * 
from renamed