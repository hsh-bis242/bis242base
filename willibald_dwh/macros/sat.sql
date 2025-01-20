{% macro sat(source_model_name, parent_ensemble, context_columns) -%}

{% set v_all_bk_columns = [] -%}
{% for current_bk in parent_ensemble.bk_columns -%}
    {% do v_all_bk_columns.append(current_bk.column_name) -%}
{% endfor -%}

SELECT  {{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_bk_columns, hashcolumn_name = "hkey_" + parent_ensemble.name) }},
        {{ source_model_name }}.sys_loadingid,
        {{ hashcolumn(source_model_name = source_model_name, list_columns = context_columns | map(attribute='column_name'), hashcolumn_name = "sys_checksum") }},

{%- endmacro -%}