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
        order_details.sales_order_id
        , order_details.sales_order_detail_id
        , orders.order_date
        , orders.customer_id
        , order_details.product_id
        , orders.ship_to_address_id as address_id
        
        , orders.territory_id
        , orders.credit_card_id
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
