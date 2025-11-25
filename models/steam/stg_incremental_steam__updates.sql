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
        s.app_id,
        s.update_seq,
        s.update_date_utc,
        s.update_title
    from source_updates s

    {% if is_incremental() %}
    left join {{ this }} t
        on  t.app_id      = s.app_id
        and t.update_seq  = s.update_seq
    where t.app_id is null          
    {% endif %}

)

select *
from final
