{% macro sat(source_model_name, parent_ensemble, context_columns) -%}

{% set v_all_bk_columns = [] -%}
{% for current_bk in parent_ensemble.bk_columns -%}
    {% do v_all_bk_columns.append(current_bk.column_name) -%}
{% endfor -%}

WITH cte_sat_data AS (
    SELECT  {{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_bk_columns, hashcolumn_name = "hkey_" + parent_ensemble.name) }},
            {{ source_model_name }}.sys_loadingid,
            {{ source_model_name }}.sys_cdc,
            {{ hashcolumn(source_model_name = source_model_name, list_columns = context_columns | map(attribute='column_name'), hashcolumn_name = "sys_checksum") }},
            {% for current_context_column in context_columns -%}
                {{ source_model_name }}.{{ current_context_column.column_name }} AS {{ current_context_column.business_name }}{% if not loop.last %},{% endif %}
            {% endfor -%}
      FROM  {{ ref(source_model_name) }}
),
cte_sat_format AS (
 SELECT {{ "hkey_" + parent_ensemble.name }},
        sys_loadingid,
        sys_cdc,
        sys_checksum,
        {% for current_context_column in context_columns -%}
            {{ current_context_column.business_name }}{% if not loop.last %},{% endif %}
        {% endfor -%}
   FROM cte_sat_data
QUALIFY COALESCE(LAG(sys_checksum) OVER (PARTITION BY {{ "hkey_" + parent_ensemble.name }} ORDER BY sys_loadingid), '') <> sys_checksum
)
SELECT  *,
        LEAD(sys_loadingid, 1, 2^31 - 1) OVER (PARTITION BY {{ "hkey_" + parent_ensemble.name }} ORDER BY sys_loadingid) AS sys_loadingid_validto
  FROM  cte_sat_format

{%- endmacro -%}