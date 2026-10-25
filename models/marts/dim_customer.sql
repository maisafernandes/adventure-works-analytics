with customer as (
    select * 
    from {{ ref('int_customer') }}
)

, dim_customer as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as customer_sk
        , customer_id
        , business_entity_id
        , full_name
        , store_name
    from customer
)

select * 
from dim_customer
