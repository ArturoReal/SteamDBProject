{{ config(
    materialized = 'table'
) }}

with current_snap as (

    select
        app_id,
        ip_name as game_name,
        release_date,
        price_usd,
        dlc_count,
        system_id,
        metacritic_score,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_steam_games') }}

),

only_current as (

    select *
    from current_snap
    where dbt_valid_to is null

)

select
    app_id,
    game_name,
    release_date,
    price_usd,
    dlc_count,
    system_id,
    metacritic_score
from only_current
