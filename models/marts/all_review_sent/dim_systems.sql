{{ config(
    materialized = 'table'
) }}

select distinct
    system_id,
    windows,
    mac,
    linux
from {{ ref('stg_steam__systems') }}
