{% macro link(source_model_name, hubs, transactional_attributes) -%}

{# Create a list of all columns needed for the links hashkey: #}

{% set v_all_columns = [] %}
{% for current_hub in hubs %}
    {% for current_bk in current_hub.bk_columns %}
        {% do v_all_columns.append(current_bk.column_name) %}
    {% endfor %}
    {% for current_transactional_attribute in transactional_attributes %}
        {% do v_all_columns.append(current_transactional_attribute.column_name) %}
    {% endfor %}
{% endfor -%}

SELECT		{{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_columns, hashcolumn_name = "hkey_" + this.name)}},
	   		min({{ source_model_name }}.sys_loadingid) AS sys_loadingid,
	   		'{{ source_model_name }}' AS sys_rsrc,
            {% for current_hub in hubs -%}
                {% set v_all_bk_columns = [] -%}
                {% for current_bk in current_hub.bk_columns -%}
                    {% do v_all_bk_columns.append(current_bk.column_name) -%}
                {% endfor -%}
                {{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_bk_columns, hashcolumn_name = "hkey_" + current_hub.name) }} {%- if not loop.last %},{% endif %}
            {% endfor %}
            {%- for current_transactional_attribute in transactional_attributes %}
                {% if loop.first %},{% endif %}
                {{ source_model_name }}.{{ current_transactional_attribute.column_name }} AS {{ current_transactional_attribute.business_name }} {%- if not loop.last %},{% endif %}
            {%- endfor %}
  FROM		{{ ref(source_model_name) }}
 WHERE		{{ source_model_name }}.sys_cdc != 'D'
{% if v_all_columns|length == 2 -%}
    {% for current_column in v_all_columns -%}
        AND		{{ source_model_name }}.{{ current_column }} IS NOT NULL
    {% endfor -%}
{% endif -%}
 GROUP BY	{{ v_all_columns | join(', ') }}

 {%- endmacro -%}