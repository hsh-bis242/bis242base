
{% macro psa_view(p_psa_table) %}

{% if execute %}

  {% set v_psa_table_node = graph.nodes.values()
     | selectattr("resource_type", "equalto", "seed")
     | selectattr("name", "equalto", p_psa_table)
     | first %}

{% endif %}
  

SELECT
    sys_loadingid,
    {% if execute %}LEAD(sys_loadingid) OVER (PARTITION BY {{ v_psa_table_node.meta.unique_key }} ORDER BY sys_loadingid ASC) IS NULL AS sys_islatest,{% endif %}
    sys_cdc,
    sys_checksum,
	{{ dbt_utils.star(from=ref(p_psa_table), except=['sys_loadingid','sys_cdc','sys_checksum']) }}
FROM {{ ref(p_psa_table) }}

{% endmacro %}