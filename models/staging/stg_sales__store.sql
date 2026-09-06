with source as (

    select * 
    from {{ source('sales', 'store') }}
), 

renamed as (

    select
        businessentityid as store_id
        , name as store_name
        , salespersonid as salesperson_id
    from source
)

select * 
from renamed