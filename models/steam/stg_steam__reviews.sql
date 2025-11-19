with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_reviews') }}

),

typed as (

    select

        try_to_number(review_id) as review_id,
        app_id,
        md5(language) as language_id,
        review_text,
        is_positive,
        steam_purchase,
        received_for_free,
        early_access,
        to_timestamp_ntz(timestamp_created) as created_at_utc,
        to_timestamp_ntz(timestamp_updated) as updated_at_utc,
        to_timestamp_ntz(load_timestamp_utc, 9) as last_loaded_utc,
        votes_up,
        votes_funny, 
        comment_count,
        try_to_number(author_steamid) as author_steamid,
        author_num_games_owned,
        author_num_reviews,
        author_playtime_forever,
        author_playtime_at_review
        
    from source

)

select *
from typed
