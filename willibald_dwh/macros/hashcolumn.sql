{% macro hashcolumn(source_model_name, list_columns, hashcolumn_name) -%}

{% set prefixed_columns = [] -%}
{% for column in list_columns -%}
    {% do prefixed_columns.append(source_model_name ~ '.' ~ column) -%}
{% endfor -%}

{{ dbt_utils.generate_surrogate_key(prefixed_columns) }} AS {{ hashcolumn_name }}

{%- endmacro %}