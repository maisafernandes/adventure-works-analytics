with source as (

    select * 
    from {{ source('person', 'person') }}
)

, renamed as (

    select
        businessentityid as person_id
        , persontype as person_type
        , firstname as first_name
        , lastname as last_name
    from source
)

select * 
from renamed