with sales_reason as (
    select * 
    from {{ ref('stg_sales__sales_reason') }}
)

, unknown_member as (
    -- Pedidos sem motivo de venda informado apontam para este membro na tabela ponte
    select
        -1 as sales_reason_id
        , 'Not informed' as sales_reason_name
        , 'Not informed' as reason_type
)

, unioned as (
    select 
        sales_reason_id
        , sales_reason_name
        , reason_type
    from sales_reason

    union all

    select 
        sales_reason_id
        , sales_reason_name
        , reason_type
    from unknown_member
)

, dim_sales_reason as (
    select
        {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} as sales_reason_sk
        , sales_reason_id
        , sales_reason_name
        , reason_type
    from unioned
)

select * 
from dim_sales_reason
