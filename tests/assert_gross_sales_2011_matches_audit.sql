-- Teste solicitado pelo CEO: a receita bruta de 2011 deve bater com o valor da auditoria contábil ($12.646.112,16).
-- Retorna linha (e falha) apenas quando o valor calculado na fato difere do auditado.
with gross_sales_2011 as (
    select
        round(sum(gross_revenue), 2) as gross_sales
    from {{ ref('fact_sales') }}
    where extract(year from order_date) = 2011
)

select
    gross_sales
from gross_sales_2011
where gross_sales != 12646112.16
