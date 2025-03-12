{% macro dk_lsat(source_model_name, parent_link_name, keys) -%}

WITH cte_reference_history AS (
	SELECT	sys_loadingid,
			sys_cdc,
			{{ keys | map(attribute="name") | join(", ") }},
			LEAD(sys_loadingid, 1, 2^31 - 1) OVER (PARTITION BY {{ keys | selectattr("is_driving_key") | map(attribute = "name") | join(", ") }} ORDER BY sys_loadingid) AS sys_loadingid_validto
	  FROM 	{{ ref(source_model_name) }}
)
SELECT	{{ hashcolumn(source_model_name = "cte_reference_history", list_columns = keys | map(attribute = "name"), hashcolumn_name = "hkey_" + parent_link_name)}},
		sys_loadingid,
		sys_loadingid_validto
  FROM 	cte_reference_history
 WHERE 	sys_cdc != 'D'
{% if keys|length == 2 -%}
	{% for current_key in keys -%}
   AND	{{ current_key.name }} IS NOT NULL
	{% endfor -%}
{% endif -%}

{%- endmacro -%}