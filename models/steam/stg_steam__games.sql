with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_games') }}

),

typed as (

    select
        app_id,
        name as ip_name,
        to_date(release_date) as release_date,
        price as price_usd,
        dlc_count,
        windows,
        mac,
        linux,
        metacritic_score
    from source

)

select *
from typed
