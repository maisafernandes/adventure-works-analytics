with date_spine as (
    -- Gera 1461 dias (4 anos: 2011 a 2014), cobrindo exatamente o período de vendas da base
    select (date '2011-01-01' + sequence.day) as date_day
    from generate_series(0, 1460) as sequence(day)
)

, dim_date as (
    select
        cast(to_char(date_day, 'YYYYMMDD') as int) as date_sk
        , date_day
        , cast(extract(year from date_day) as int) as year
        , cast(extract(month from date_day) as int) as month
        , trim(to_char(date_day, 'Month')) as month_name
        , cast(extract(day from date_day) as int) as day
        , cast(extract(quarter from date_day) as int) as quarter
    from date_spine
)

select * 
from dim_date
