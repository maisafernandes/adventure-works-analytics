with source as (

    select * 
    from {{ source('sales', 'salesreason') }}
)

, renamed as (

    select
        cast(salesreasonid as int) as sales_reason_id
        , cast(name as varchar) as sales_reason_name
        , cast(reasontype as varchar) as reason_type
    from source
)

select * 
from renamed