with source as (

    select * 
    from {{ source('person', 'address') }}
)

, renamed as (

    select
        addressid as address_id
        , addressline1 as address_line_1
        , city as city
        , stateprovinceid as state_province_id
        , postalcode as postal_code
    from source
)

select * 
from renamed