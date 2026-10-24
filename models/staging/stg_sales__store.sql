with source as (

    select * 
    from {{ source('sales', 'store') }}
), 

renamed as (

    select
        cast(businessentityid as int) as store_id
        , cast(name as varchar) as store_name
        , cast(salespersonid as int) as salesperson_id
    from source
)

select * 
from renamed