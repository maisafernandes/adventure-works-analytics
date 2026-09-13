with source as (

    select * 
    from {{ source('sales', 'salesreason') }}
)

, renamed as (

    select
        salesreasonid as sales_reason_id
        , name as sales_reason_name
        , reasontype as reason_type
    from source
)

select * 
from renamed