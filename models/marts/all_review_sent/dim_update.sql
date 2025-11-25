{{ config(
    materialized = 'table'
) }}

select
    app_id,
    app_id || '-' || update_seq as update_id,
    update_seq,
    update_date_utc,
    update_title
from {{ ref('stg_incremental_steam__updates') }}
