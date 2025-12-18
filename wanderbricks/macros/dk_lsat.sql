{% macro dk_lsat(source_model_name, parent_link_name, keys) -%}

with cte_reference_history as (
	select	sys_loadingid,
			sys_cdc,
			{{ keys | map(attribute="name") | join(", ") }},
			lead(sys_loadingid, 1, 2^31 - 1) over (partition by {{ keys | selectattr("is_driving_key") | map(attribute = "name") | join(", ") }} order by sys_loadingid) as sys_loadingid_validto
	  from 	{{ ref(source_model_name) }}
)
select	{{ hashcolumn(source_model_name = "cte_reference_history", list_columns = keys | map(attribute = "name"), hashcolumn_name = "hkey_" + parent_link_name)}},
		sys_loadingid,
		sys_loadingid_validto
  from 	cte_reference_history
 where 	sys_cdc != 'd'
{% if keys|length == 2 -%}
	{% for current_key in keys -%}
   and	{{ current_key.name }} is not null
	{% endfor -%}
{% endif -%}

{%- endmacro -%}