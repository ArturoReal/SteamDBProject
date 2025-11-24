{{ config(
    materialized = 'table'
) }}

select distinct
    language_id,
    language_name
from {{ ref('stg_steam__language') }}
