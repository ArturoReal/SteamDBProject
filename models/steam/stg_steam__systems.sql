with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_games') }}

),

typed as (

    select distinct
        md5(CONCAT_WS('|', windows, mac, linux)) as system_id,
        windows,
        mac,
        linux
    from source

)

select *
from typed
