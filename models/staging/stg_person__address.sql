with source as (

    select * 
    from {{ source('person', 'address') }}
)

, renamed as (

    select
        cast(addressid as int) as address_id
        , cast(addressline1 as varchar) as address_line_1
        , cast(city as varchar) as city
        , cast(stateprovinceid as int) as state_province_id
        , cast(postalcode as varchar) as postal_code
    from source
)

select * 
from renamed