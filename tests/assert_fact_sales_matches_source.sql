-- A fato deve ter exatamente uma linha por item de pedido da origem e a mesma receita bruta total (sem fan-out).
with fact as (
    select
        count(*) as fact_rows
        , round(sum(gross_revenue), 2) as fact_gross
    from {{ ref('fact_sales') }}
)

, source as (
    select
        count(*) as source_rows
        , round(sum(orderqty * unitprice), 2) as source_gross
    from {{ source('sales', 'salesorderdetail') }}
)

select
    fact.fact_rows
    , source.source_rows
    , fact.fact_gross
    , source.source_gross
from fact
cross join source
where fact.fact_rows != source.source_rows
    or fact.fact_gross != source.source_gross
