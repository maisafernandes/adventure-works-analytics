with source as (

    select * 
    from {{ source('sales', 'salesterritory') }}
)

,renamed as (

    select
        territoryid as territory_id
        , name as territory_name
        , countryregioncode as country_code
        , "group" as territory_group
    from source
)

select * 
from renamed