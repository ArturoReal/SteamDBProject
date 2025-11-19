with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_updates') }}

),

typed as (

    select

        app_id,
        update_seq,
        to_timestamp_ntz(update_date_raw) as update_date_utc,
        update_title
        
    from source

)

select *
from typed
