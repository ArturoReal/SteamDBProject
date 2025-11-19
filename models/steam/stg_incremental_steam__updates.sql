{{ config(
    materialized = 'incremental',
    unique_key = ['app_id', 'update_seq'],
    incremental_strategy = 'merge'
) }}

with source_updates as (

    select
        app_id,
        update_seq,
        to_timestamp_ntz(update_date_raw) as update_date_utc,
        update_title
    from {{ source('steam_bronze', 'steam_updates') }}

),

final as (

    select
        app_id,
        update_seq,
        update_date_utc,
        update_title
    from source_updates

    {% if is_incremental() %}
        where update_date_utc >
              coalesce(
                  (select max(update_date_utc) from {{ this }}),
                  to_timestamp_ntz('1970-01-01')
              )
    {% endif %}

)

select *
from final
