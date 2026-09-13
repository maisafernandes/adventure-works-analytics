with sales_reason as (
    select * 
    from {{ ref('stg_sales__sales_reason') }}
)

, dim_sales_reason as (
    select
        sales_reason_id
        , sales_reason_name
        , reason_type
    from sales_reason
)

select * 
from dim_sales_reason