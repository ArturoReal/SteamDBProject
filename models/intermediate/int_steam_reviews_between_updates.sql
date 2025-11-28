{{ config(
    materialized = 'view'
) }}

with updates as (

    select
        app_id,
        update_seq,
        update_title,
        update_date_utc,
        lead(update_date_utc) over (
            partition by app_id
            order by update_date_utc
        ) as next_update_date_utc
    from {{ ref('stg_incremental_steam__updates') }}

),

reviews as (

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
        votes_up,
        votes_funny,
        comment_count,
        author_steamid,
        author_num_games_owned,
        author_num_reviews,
        author_playtime_forever_hours,
        author_playtime_at_review_hours,
        dbt_valid_from,
        dbt_valid_to
    from {{ ref('snap_steam_reviews') }}

),

joined as (

    select
        r.review_id,
        r.app_id,
        r.language_id,
        r.review_text,
        r.is_positive,
        r.steam_purchase,
        r.received_for_free,
        r.early_access,
        r.created_at_utc,
        r.updated_at_utc,
        r.votes_up,
        r.votes_funny,
        r.comment_count,
        r.author_steamid,
        r.author_num_games_owned,
        r.author_num_reviews,
        r.author_playtime_forever_hours,
        r.author_playtime_at_review_hours,

        -- periodo de validez de cada review
        r.dbt_valid_from as review_valid_from_utc,
        r.dbt_valid_to   as review_valid_to_utc,

        -- update asociada 
        u.update_seq          as current_update_seq,
        u.update_title        as current_update_title,
        u.update_date_utc     as current_update_date_utc,
        u.next_update_date_utc as next_update_date_utc

    from reviews r
    left join updates u
        on  r.app_id = u.app_id
        and r.dbt_valid_from >= u.update_date_utc
        and (
              r.dbt_valid_from < u.next_update_date_utc
              or u.next_update_date_utc is null
            )

)

select *
from joined
