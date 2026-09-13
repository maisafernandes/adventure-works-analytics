with credit_card as (
    select * 
    from {{ ref('stg_sales__credit_card') }}
)

, dim_credit_card as (
    select
        credit_card_id
        , card_type
    from credit_card
)

select * 
from dim_credit_card