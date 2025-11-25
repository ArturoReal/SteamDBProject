-- Falla si hay más de una fila "actual" (dbt_valid_to is null) por review_id
select
    review_id,
    count(*) as current_rows
from {{ ref('snap_steam_reviews') }}
where dbt_valid_to is null
group by review_id
having count(*) > 1
