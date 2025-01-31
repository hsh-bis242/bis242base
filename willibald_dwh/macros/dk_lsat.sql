{% macro dk_lsat    (source_model_name, driving_keys, follower_keys) -%}

-- Needs to be something like this:
/* WITH cte_lk_history AS (
	 SELECT	v_webshop_produktkategorie.katid,
			v_webshop_produktkategorie.oberkatid,
			v_webshop_produktkategorie.sys_loadingid
	   FROM	dev_willibald_dwh.willibald_psa_sl.v_webshop_produktkategorie
	QUALIFY	COALESCE(LAG(v_webshop_produktkategorie.oberkatid) OVER (PARTITION BY v_webshop_produktkategorie.katid ORDER BY v_webshop_produktkategorie.sys_loadingid), '') <> v_webshop_produktkategorie.oberkatid
)
SELECT	md5(cast(coalesce(cast(cte_lk_history.katid as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(cte_lk_history.oberkatid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS hkey_lnk_productcategory_supercategory,
		cte_lk_history.sys_loadingid AS sys_validfrom_loadingid,
		LEAD(cte_lk_history.sys_loadingid) OVER (PARTITION BY cte_lk_history.katid ORDER BY cte_lk_history.sys_loadingid) AS sys_validto_loadingid
 FROM 	cte_lk_history;
*/
-- But this is not working properly.

{%- endmacro -%}