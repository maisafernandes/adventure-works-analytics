with source as (

    select * 
    from {{ source('person', 'stateprovince') }}
)

, renamed as (

    select
        cast(stateprovinceid as int) as state_province_id
        , cast(stateprovincecode as varchar) as state_province_code
        , cast(countryregioncode as varchar) as country_region_code
        , cast(name as varchar) as state_name
        , cast(territoryid as int) as territory_id
    from source
)

select * 
from renamed