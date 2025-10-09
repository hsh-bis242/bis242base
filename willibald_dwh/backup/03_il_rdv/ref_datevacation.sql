SELECT  {{ dbt_utils.star(from=ref("calendar_ferien"), except=["dbt_scd_id", "dbt_updated_at", "dbt_valid_from", "dbt_valid_to"]) }}
  FROM  {{ ref("calendar_ferien") }}
 WHERE  dbt_valid_to IS NULL