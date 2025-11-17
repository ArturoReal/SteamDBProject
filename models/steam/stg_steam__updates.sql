with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_updates') }}

),

typed as (

    select

        *
        
    from source

)

select *
from typed
