{% macro hkey(source_model_name, list_columns, hkey_name) -%}

sha256(
            {%- for current_column_name in list_columns -%}
                COALESCE(TRIM({{ source_model_name }}.{{ current_column_name }}::VARCHAR),'') {%- if not loop.last %} || '|' || {% endif %}
            {%- endfor -%}
        ) AS hkey_{{ hkey_name }}

{%- endmacro -%}