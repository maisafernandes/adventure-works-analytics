with customer as (
    select * 
    from {{ ref('int_customer') }}
)

, dim_customer as (
    select
        customer_id
        , business_entity_id
        , full_name
        , store_name
    from customer
)

select * 
from dim_customer