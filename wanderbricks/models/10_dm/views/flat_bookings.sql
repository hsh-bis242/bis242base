-- flat denormalized bookings table
with employees_per_host as (
  select
    host_id,
    count(*) as host_employee_count
  from {{ ref('dim_employee') }}
  where is_currently_employed is true
  group by host_id
),

booking_base as (
  select
    fb.booking_id,
    fb.user_id,
    fb.property_id,
    fb.check_in,
    fb.check_out,
    fb.guests_count,
    fb.total_amount,
    fb.status,
    fb.created_at as booking_created_at,
    fb.updated_at as booking_updated_at,
    datediff(fb.check_out, fb.check_in) as nights,
    case when datediff(fb.check_out, fb.check_in) = 0 then null
         else fb.total_amount / nullif(datediff(fb.check_out, fb.check_in), 0)
    end as price_per_night
  from {{ ref('fact_bookings') }} fb
)

select
  b.booking_id,
  b.user_id,
  b.property_id,
  b.check_in,
  b.check_out,
  b.nights,
  b.guests_count,
  b.total_amount,
  b.price_per_night,
  b.status,
  b.booking_created_at,
  b.booking_updated_at,

  du.name as user_name,
  du.email as user_email,
  du.country as user_country,
  du.user_type,

  dp.host_id,
  dp.title as property_title,
  dp.base_price as property_base_price,
  dp.property_type,
  dp.max_guests,
  dp.bedrooms,
  dp.bathrooms,
  dp.property_latitude,
  dp.property_longitude,

  dd.destination as destination_name,
  dd.country as destination_country,

  coalesce(eph.host_employee_count, 0) as host_employee_count
from booking_base b
left join {{ ref('dim_user') }} du on b.user_id = du.user_id
left join {{ ref('dim_properties') }} dp on b.property_id = dp.property_id
left join {{ ref('dim_destinations') }} dd on dp.destination_id = dd.destination_id
left join employees_per_host eph on dp.host_id = eph.host_id
