
select
    user_id,
    email,
    name,
    country,
    user_type,
    created_at,
    is_business,
    company_name
from {{ source('wanderbricks', 'users') }}