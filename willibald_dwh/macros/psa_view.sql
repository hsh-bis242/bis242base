
{% macro psa_view(p_psa_table) %}

{% set v_psa_table_unique_key = 1 %}

{% if execute %}

  {% set v_psa_table_node = graph.nodes.values()
     | selectattr("resource_type", "equalto", "seed")
     | selectattr("name", "equalto", p_psa_table)
     | first %}

  {% set v_psa_table_unique_key = v_psa_table_node.meta.unique_key %}

{% endif %}

SELECT
  "sys_loadingid",
  LEAD("sys_loadingid") OVER (PARTITION BY {{ v_psa_table_unique_key }} ORDER BY "sys_loadingid" ASC) IS NULL AS "sys_islatest",
  "sys_cdc",
  "sys_checksum",
	{{ dbt_utils.star(from=ref(p_psa_table), except=['sys_loadingid','sys_cdc','sys_checksum']) }}
FROM {{ ref(p_psa_table) }}

{% endmacro %}