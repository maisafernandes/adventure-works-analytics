with order_reason as (
    select * 
    from {{ ref('stg_sales__sales_order_header_sales_reason') }}
)

, bridge_sales_order_reason as (
    select
        cast(sales_order_id as varchar) || '-' || cast(sales_reason_id as varchar) as sales_order_reason_key
        , sales_order_id
        , sales_reason_id
    from order_reason
)

select * 
from bridge_sales_order_reason
