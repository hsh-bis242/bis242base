{% macro psa_view(p_psa_table) %}

{% set v_psa_table_unique_key = [] %}

{% if execute %}

  {% set v_psa_table_node = graph.nodes.values()
     | selectattr("resource_type", "in", ["seed", "model"])
     | selectattr("name", "equalto", p_psa_table)
     | first %}

  {% set v_psa_table_unique_key = v_psa_table_node.meta.unique_key %}

{% endif %}

select
  sys_loadingid,
  lead(sys_loadingid) over (partition by {{ v_psa_table_unique_key | join(", ") }} order by sys_loadingid asc) is null as sys_islatest,
  sys_cdc,
  sys_checksum,
	{{ dbt_utils.star(from=ref(p_psa_table), except=['sys_loadingid','sys_cdc','sys_checksum']) }}
from {{ ref(p_psa_table) }}

{% endmacro %}