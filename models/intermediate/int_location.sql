with address as (
    select * 
    from {{ ref('stg_person__address') }}
)

, state_province as (
    select * 
    from {{ ref('stg_person__state_province') }}
)

, territory as (
    select * 
    from {{ ref('stg_sales__sales_territory') }}
)

, int_location as (
    select
        address.address_id
        , address.city
        , state_province.state_name as state_province_name
        , state_province.country_region_code
        , state_province.territory_id
        , territory.territory_name
    from address
    left join state_province
        on address.state_province_id = state_province.state_province_id
    left join territory
        on state_province.territory_id = territory.territory_id
)

select * 
from int_location
