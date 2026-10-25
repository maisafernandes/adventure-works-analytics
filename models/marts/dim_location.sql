with location as (
    select * 
    from {{ ref('int_location') }}
)

, dim_location as (
    select
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} as location_sk
        , address_id
        , city
        , state_province_name
        , country_region_code
        , territory_id
        , territory_name
    from location
)

select * 
from dim_location
