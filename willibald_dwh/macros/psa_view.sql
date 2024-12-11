{% macro psa_view(p_psa_table, p_unique_key) %}
SELECT
    sys_loadingid,
    {{ debug() }}
    LEAD(sys_loadingid) OVER (PARTITION BY {{ graph.nodes[p_psa_table].meta.unique_key }} ORDER BY sys_loadingid ASC) IS NULL AS sys_islatest,
    sys_cdc,
    sys_checksum,
	{{ dbt_utils.star(from=ref(p_psa_table), except=['sys_loadingid','sys_cdc','sys_checksum']) }}
FROM {{ ref(p_psa_table) }}
{% endmacro %}