{% macro hashcolumn(source_model_name, list_columns, hashcolumn_name) -%}

sha256(
            {%- for current_column_name in list_columns -%}
                COALESCE(TRIM({{ source_model_name }}.{{ current_column_name }}::VARCHAR),'') {%- if not loop.last %} || '|' || {% endif %}
            {%- endfor -%}
        ) AS {{ hashcolumn_name }}

{%- endmacro %}