{{ config(
    materialized = 'table'
) }}

with base as (

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
        review_valid_from_utc,
        review_valid_to_utc,
        votes_up,
        votes_funny,
        comment_count,
        author_steamid,
        author_num_games_owned,
        author_num_reviews,
        author_playtime_forever_hours,
        author_playtime_at_review_hours,
        current_update_seq,
        current_update_title,
        current_update_date_utc,
        next_update_date_utc
    from {{ ref('int_steam_reviews_between_updates') }}

),

final as (

    select
        review_id,
        app_id,
        language_id,

        -- clave de fecha de la VERSIÓN de la review
        to_date(review_valid_from_utc) as review_date_id,

        -- clave de update 
        app_id || '-' || current_update_seq as update_id,

        review_text,
        votes_up,
        votes_funny,
        comment_count,
        author_num_games_owned,
        author_num_reviews,
        author_playtime_forever_hours,
        author_playtime_at_review_hours,
        is_positive,
        steam_purchase,
        received_for_free,
        early_access,
        current_update_seq,
        current_update_date_utc,
        next_update_date_utc,
        review_valid_from_utc,
        review_valid_to_utc

    from base
)

select *
from final;
