with source as (

    select * 
    from {{ source('sales', 'creditcard') }}
)

, renamed as (

    select
        cast(creditcardid as int) as credit_card_id
        , cast(cardtype as varchar) as card_type
    from source
)

select * 
from renamed