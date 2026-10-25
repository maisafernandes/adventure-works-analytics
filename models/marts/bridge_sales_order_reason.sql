with order_reason as (
    select * 
    from {{ ref('stg_sales__sales_order_header_sales_reason') }}
)

, orders as (
    select * 
    from {{ ref('stg_sales__orders') }}
)

, order_reason_all as (
    -- Pedidos sem motivo recebem o membro -1 (Not informed), garantindo ao menos uma linha por pedido
    select
        orders.sales_order_id
        , coalesce(order_reason.sales_reason_id, -1) as sales_reason_id
    from orders
    left join order_reason
        on orders.sales_order_id = order_reason.sales_order_id
)

, bridge_sales_order_reason as (
    select
        {{ dbt_utils.generate_surrogate_key(['sales_order_id', 'sales_reason_id']) }} as sales_order_reason_sk
        , {{ dbt_utils.generate_surrogate_key(['sales_order_id']) }} as sales_order_sk
        , {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} as sales_reason_sk
    from order_reason_all
)

select * 
from bridge_sales_order_reason
