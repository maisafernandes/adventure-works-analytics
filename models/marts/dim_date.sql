with date_spine as (
    -- Gera 1461 dias (4 anos: 2011 a 2014), cobrindo exatamente o período de vendas da base
    select (date '2011-01-01' + sequence.day) as date_day
    from generate_series(0, 1460) as sequence(day)
)

, dim_date as (
    select
        date_day
        , extract(year from date_day) as year
        , extract(month from date_day) as month
        , extract(day from date_day) as day
        , extract(quarter from date_day) as quarter
    from date_spine
)

select * 
from dim_date