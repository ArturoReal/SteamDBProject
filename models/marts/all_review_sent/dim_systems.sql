{{ config(
    materialized = 'table'
) }}

select distinct
    system_id,
    windows,
    mac,
    linux,
    case
        when windows = true  and mac = true  and linux = true  then 'Windows + Mac + Linux'
        when windows = true  and mac = true  and linux = false then 'Windows + Mac'
        when windows = true  and mac = false and linux = true  then 'Windows + Linux'
        when windows = false and mac = true  and linux = true  then 'Mac + Linux'
        when windows = true  and mac = false and linux = false then 'Only Windows'
        when windows = false and mac = true  and linux = false then 'Only Mac'
        when windows = false and mac = false and linux = true  then 'Only Linux'
        else 'No platform'
    end as system_combo_name
from {{ ref('stg_steam__systems') }}
