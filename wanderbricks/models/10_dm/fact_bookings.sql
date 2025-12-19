{{ config(materialized='table') }}

select
    booking_id,
    user_id,
    property_id,
    check_in,
    check_out,
    guests_count,
    total_amount,
    {{eur_to_usd('total_amount')}},
    status,
    created_at,
    updated_at
from {{ source('wanderbricks', 'bookings') }}