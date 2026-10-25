-- Teste solicitado pelo CEO: a receita bruta de 2011 deve bater com o valor da auditoria contábil ($12.646.112,16).
-- Retorna linha (e falha) apenas quando o valor calculado na fato difere do auditado.
with gross_sales_2011 as (
    select
        round(sum(fact_sales.gross_revenue), 2) as gross_sales
    from {{ ref('fact_sales') }} as fact_sales
    inner join {{ ref('dim_date') }} as dim_date
        on fact_sales.date_sk = dim_date.date_sk
    where dim_date.year = 2011
)

select
    gross_sales
from gross_sales_2011
where gross_sales != 12646112.16
