with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_games') }}

),

typed as (

    select

        *
    from source

)

select *
from typed
