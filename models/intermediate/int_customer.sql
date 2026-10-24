with customer as (

    select * 
    from {{ ref('stg_sales__customer') }}
)

, person as (

    select * 
    from {{ ref('stg_person__person') }}
)

, store as (

    select * 
    from {{ ref('stg_sales__store') }}
)

, int_customer as (

    select
        customer.customer_id
        -- Unifica o ID dependendo se o cliente é pessoa física ou loja (PJ)
        , coalesce(customer.person_id, customer.store_id) as business_entity_id  
        -- Concatena o nome e sobrenome, tratando possíveis nulos
        , trim(coalesce(person.first_name, '') || ' ' || coalesce(person.last_name, '')) as full_name 
        , store.store_name
    from customer
    left join person
        on customer.person_id = person.person_id
    left join store
        on customer.store_id = store.store_id
)

select * 
from int_customer