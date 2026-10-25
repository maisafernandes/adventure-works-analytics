with orders as (
    select * 
    from {{ ref('stg_sales__orders') }}
)

, order_details as (
    select * 
    from {{ ref('stg_sales__order_details') }}
)

, fact_sales as (
    select
        {{ dbt_utils.generate_surrogate_key(['order_details.sales_order_id', 'order_details.sales_order_detail_id']) }} as sales_order_detail_sk
        , {{ dbt_utils.generate_surrogate_key(['order_details.sales_order_id']) }} as sales_order_sk
        , cast(to_char(orders.order_date, 'YYYYMMDD') as int) as date_sk
        , {{ dbt_utils.generate_surrogate_key(['orders.customer_id']) }} as customer_sk
        , {{ dbt_utils.generate_surrogate_key(['order_details.product_id']) }} as product_sk
        , {{ dbt_utils.generate_surrogate_key(['orders.ship_to_address_id']) }} as location_sk
        , {{ dbt_utils.generate_surrogate_key(['coalesce(orders.credit_card_id, -1)']) }} as credit_card_sk

        -- Chaves degeneradas, mantidas para rastreabilidade com a origem
        , order_details.sales_order_id
        , order_details.sales_order_detail_id

        , order_details.order_qty
        , order_details.unit_price
        , order_details.unit_price_discount

        -- Receita bruta (sem desconto) e receita líquida do item (já abatendo o desconto)
        , (order_details.order_qty * order_details.unit_price) as gross_revenue
        , (order_details.order_qty * order_details.unit_price * order_details.unit_price_discount) as discount_amount
        , (order_details.order_qty * order_details.unit_price * (1 - order_details.unit_price_discount)) as revenue
    from order_details
    inner join orders
        on order_details.sales_order_id = orders.sales_order_id
)

select * 
from fact_sales
