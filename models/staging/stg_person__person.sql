with source as (

    select * 
    from {{ source('person', 'person') }}
)

, renamed as (

    select
        cast(businessentityid as int) as person_id
        , cast(persontype as varchar) as person_type
        , cast(firstname as varchar) as first_name
        , cast(lastname as varchar) as last_name
    from source
)

select * 
from renamed