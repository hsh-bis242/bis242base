SELECT  {{ dbt_utils.star(from=ref("calendar_feiertag"), except=["dbt_scd_id", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to"]) }}
  FROM  {{ ref("calendar_feiertag") }}
 WHERE  dbt_valid_to IS NULL