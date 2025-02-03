{% macro reftable(source_model_name, unique_key, context_columns) -%}

{% set v_all_columns = unique_key + context_columns -%}

WITH cte_ref_data AS (
    SELECT  {{ source_model_name }}.sys_loadingid,
            LEAD({{ source_model_name }}.sys_loadingid) OVER (PARTITION BY {{ unique_key | map(attribute="column_name") | join(", ") }} ORDER BY {{ source_model_name }}.sys_loadingid ASC) AS sys_loadingid_validto,
            {{ source_model_name }}.sys_cdc,
            {{ hashcolumn(source_model_name = source_model_name, list_columns = context_columns | map(attribute="column_name"), hashcolumn_name = "sys_checksum") }},
            {% for current_column in v_all_columns -%}
                {{ source_model_name }}.{{ current_column.column_name }} AS {{ current_column.business_name }}{% if not loop.last %},{% endif %}
            {% endfor -%}
      FROM  {{ ref(source_model_name) }}
)
 SELECT sys_loadingid,
        sys_loadingid_validto,
        sys_cdc,
        sys_checksum,
        {% for current_column in v_all_columns -%}
            {{ current_column.business_name }}{% if not loop.last %},{% endif %}
        {% endfor -%}
   FROM cte_ref_data
  WHERE sys_cdc != 'D'
QUALIFY COALESCE(LAG(sys_checksum) OVER (PARTITION BY {{ unique_key | map(attribute="business_name") | join(", ") }} ORDER BY sys_loadingid), '') <> sys_checksum

{%- endmacro -%}