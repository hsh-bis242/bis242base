SELECT
    destination_id,
    destination,
    country,
    state_or_province,
    state_or_province_code,
    description
FROM {{ source('wanderbricks', 'destinations') }}