{% snapshot snap_steam_reviews %}

{{
  config(
    target_database = env_var('DBT_ENVIRONMENTS') ~ '_SILVER_DB',
    target_schema   = 'SNAPSHOTS',
    unique_key      = 'review_id',
    strategy        = 'timestamp',
    updated_at      = 'updated_at_utc'
  )
}}

select

    review_id,
    app_id,
    language_id,
    review_text,
    is_positive,
    steam_purchase,
    received_for_free,
    early_access,
    created_at_utc,
    updated_at_utc,
    last_loaded_utc,
    votes_up,
    votes_funny,
    comment_count,
    author_steamid,
    author_num_games_owned,
    author_num_reviews,
    author_playtime_forever,
    author_playtime_at_review

from {{ ref('stg_steam__reviews') }}

{% endsnapshot %}
