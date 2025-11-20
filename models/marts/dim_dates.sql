{{ config(
    materialized = 'table'
) }}

with bounds as (

    select
        least(
            (select min(to_date(created_at_utc)) from {{ ref('stg_steam__reviews') }}),
            (select min(to_date(update_date_utc)) from {{ ref('stg_incremental_steam__updates') }})
        ) as min_date,
        greatest(
            (select max(to_date(created_at_utc)) from {{ ref('stg_steam__reviews') }}),
            (select max(to_date(update_date_utc)) from {{ ref('stg_incremental_steam__updates') }})
        ) as max_date

),

date_spine as (

    select
        dateadd(day, seq4(), min_date) as date_day,
        max_date
    from bounds,
         table(generator(rowcount => 365 * 20))
)

select
    date_day as date_key,
    date_day,
    year(date_day) as year,
    month(date_day) as month,
    day(date_day) as day,
    to_char(date_day, 'YYYY-MM') as year_month,
    dayofweekiso(date_day) as weekday_iso,
    to_char(date_day, 'DY') as weekday_short
from date_spine
where date_day <= max_date
