with source as (

    select * 
    from {{ source('person', 'stateprovince') }}
)

, renamed as (

    select
        stateprovinceid as state_province_id
        , stateprovincecode as state_province_code
        , countryregioncode as country_region_code
        , name as state_name
        , territoryid as territory_id
    from source
)

select * 
from renamed