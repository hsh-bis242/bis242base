select
    destination_id,
    destination,
    country,
    state_or_province,
    state_or_province_code,
    description
from {{ source('wanderbricks', 'destinations') }}