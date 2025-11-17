with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_reviews') }}

),

typed as (

    select

        review_id                          as review_id,
        app_id                             as app_id,
        language                           as language,
        review_text                        as review_text,
        is_positive                        as is_positive,
        steam_purchase                     as steam_purchase,
        received_for_free                  as received_for_free,
        early_access                       as early_access,
        to_timestamp_ntz(timestamp_created) as created_at_utc,
        to_timestamp_ntz(timestamp_updated) as updated_at_utc,
        to_timestamp_ntz(load_timestamp_utc, 9) as last_loaded_utc,
        votes_up                           as votes_up,
        votes_funny                        as votes_funny, 
        comment_count                      as comment_count,
        author_steamid                     as author_steamid,
        author_num_games_owned             as author_num_games_owned,
        author_num_reviews                 as author_num_reviews,
        author_playtime_forever            as author_playtime_forever,
        author_playtime_at_review          as author_playtime_at_review
        
    from source

)

select *
from typed
