with source as (
    select * 
    from {{ source('sales', 'salesorderheader') }}
)

, renamed as (
    select
        cast(salesorderid as int) as sales_order_id
        , cast(customerid as int) as customer_id
        , cast(territoryid as int) as territory_id
        , cast(creditcardid as int) as credit_card_id
        , cast(shiptoaddressid as int) as ship_to_address_id

        -- Datas e Status
        , cast(orderdate as date) as order_date
        , cast(status as int) as order_status

        -- Métricas / Valores financeiros brutos
        , cast(subtotal as numeric(18, 4)) as sub_total
        , cast(taxamt as numeric(18, 4)) as tax_amount
        , cast(freight as numeric(18, 4)) as freight
        , cast(totaldue as numeric(18, 4)) as total_due
    from source
)

select * 
from renamed