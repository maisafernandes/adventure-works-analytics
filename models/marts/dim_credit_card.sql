with credit_card as (
    select * 
    from {{ ref('stg_sales__credit_card') }}
)

, unknown_member as (
    -- Pedidos sem cartão (3,6% da base) apontam para este membro, para que o filtro de cartão não os descarte
    select
        -1 as credit_card_id
        , 'Not informed' as card_type
)

, unioned as (
    select 
        credit_card_id
        , card_type
    from credit_card

    union all

    select 
        credit_card_id
        , card_type
    from unknown_member
)

, dim_credit_card as (
    select
        {{ dbt_utils.generate_surrogate_key(['credit_card_id']) }} as credit_card_sk
        , credit_card_id
        , card_type
    from unioned
)

select * 
from dim_credit_card
