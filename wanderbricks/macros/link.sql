{% macro link(source_model_name, hubs, transactional_attributes) -%}

{# create a list of all columns needed for the links hashkey: -#}

{% set v_all_columns = [] -%}
{% for current_hub in hubs -%}
    {% for current_bk in current_hub.bk_columns -%}
        {% do v_all_columns.append(current_bk.column_name) -%}
    {% endfor -%}
{% endfor -%}
{% for current_transactional_attribute in transactional_attributes -%}
    {% do v_all_columns.append(current_transactional_attribute.column_name) -%}
{% endfor -%}

select		{{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_columns, hashcolumn_name = "hkey_" + this.name)}},
    		min({{ source_model_name }}.sys_loadingid) as sys_loadingid,
    		'{{ source_model_name }}' as sys_rsrc,
            {% for current_hub in hubs -%}
                {% set v_all_bk_columns = [] -%}
                {% for current_bk in current_hub.bk_columns -%}
                    {% do v_all_bk_columns.append(current_bk.column_name) -%}
                {% endfor -%}
                {{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_bk_columns, hashcolumn_name = "hkey_" + current_hub.name) }} {%- if not loop.last %},{% endif %}
            {% endfor -%}
            {% for current_transactional_attribute in transactional_attributes -%}
                {% if loop.first %},{% endif -%}
                {{ source_model_name }}.{{ current_transactional_attribute.column_name }} as {{ current_transactional_attribute.business_name }} {%- if not loop.last %},{% endif %}
            {% endfor -%}
  from		{{ ref(source_model_name) }}
 where		{{ source_model_name }}.sys_cdc != 'd'
{% if v_all_columns|length == 2 -%}
    {% for current_column in v_all_columns -%}
        and		{{ source_model_name }}.{{ current_column }} is not null
    {% endfor -%}
{% endif -%}
 group by	{{ v_all_columns | join(', ') }}

 {%- endmacro -%}