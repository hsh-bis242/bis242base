{% macro dk_lsat    (source_model_name, driving_keys, follower_keys) -%}

-- Needs to be something like this:
/*
WITH cte_reference_history AS (
	SELECT	sys_loadingid,
			sys_cdc,
			katid,
			oberkatid,
			LEAD(sys_loadingid) OVER (PARTITION BY katid ORDER BY sys_loadingid) AS sys_loadingid_validto
	  FROM 	willibald_psa_sl.v_webshop_produktkategorie
)
SELECT	md5(cast(coalesce(cast(cte_reference_history.katid as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(cte_reference_history.oberkatid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS hkey_lnk_productcategory_supercategory,
		sys_loadingid,
		sys_loadingid_validto
  FROM 	cte_reference_history
 WHERE 	sys_cdc != 'D';
*/

{%- endmacro -%}