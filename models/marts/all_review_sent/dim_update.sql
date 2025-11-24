{{ config(
    materialized = 'table'
) }}

select
    app_id,
    update_seq,
    app_id || '-' || update_seq as update_key,
    update_date_utc,
    update_title
from {{ ref('stg_incremental_steam__updates') }}
