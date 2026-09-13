with location as (
    select * 
    from {{ ref('int_location') }}
)

, dim_location as (
    select
        address_id
        , city
        , state_province_name
        , country_region_code
        , territory_id
    from location
)

select * 
from dim_location