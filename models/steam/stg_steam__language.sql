with source as (

    select
        *
    from {{ source('steam_bronze', 'steam_reviews') }}

),

typed as (

    select distinct

        md5(language) as language_id,
        language as language_name
        
    from source

)

select *
from typed
