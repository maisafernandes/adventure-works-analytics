with orders as (
    select * 
    from {{ ref('stg_sales__orders') }}
)

, dim_sales_order as (
    select
        {{ dbt_utils.generate_surrogate_key(['sales_order_id']) }} as sales_order_sk
        , sales_order_id
        , order_status
        , case order_status
            when 1 then 'In process'
            when 2 then 'Approved'
            when 3 then 'Backordered'
            when 4 then 'Rejected'
            when 5 then 'Shipped'
            when 6 then 'Cancelled'
        end as order_status_name
    from orders
)

select * 
from dim_sales_order
