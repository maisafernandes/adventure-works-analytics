with source as (

    select * 
    from {{ source('sales', 'salesterritory') }}
)

,renamed as (

    select
        cast(territoryid as int) as territory_id
        , cast(name as varchar) as territory_name
        , cast(countryregioncode as varchar) as country_code
        , cast("group" as varchar) as territory_group
    from source
)

select * 
from renamed