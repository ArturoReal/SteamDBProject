{% snapshot snap_steam_games %}

{{
  config(
    target_database = env_var('DBT_ENVIRONMENTS') ~ '_SILVER_DB',
    target_schema   = 'SNAPSHOTS',
    unique_key      = 'app_id',
    strategy        = 'check',
    check_cols      = [
      'ip_name',
      'release_date',
      'price_usd',
      'dlc_count',
      'windows',
      'mac',
      'linux',
      'metacritic_score'
    ]
  )
}}

select
    app_id,
    ip_name,
    release_date,
    price_usd,
    dlc_count,
    windows,
    mac,
    linux,
    metacritic_score
from {{ ref('stg_steam__games') }}

{% endsnapshot %}
