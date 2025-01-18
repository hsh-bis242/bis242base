{% macro link(source_model_name, hubs, transactional_attributes) -%}

{# Create a list of all columns needed for the links hashkey: #}

{% set v_all_columns = [] %}
{% for current_hub in hubs %}
    {% for current_bk in current_hub.bk_columns %}
        {% do v_all_columns.append(current_bk.column_name) %}
    {% endfor %}
{% endfor -%}

SELECT		{{hkey(source_model_name = source_model_name, list_columns = v_all_columns, hkey_name = this.name)}},
	   		min({{ source_model_name }}.sys_loadingid) AS sys_loadingid,
	   		'{{ source_model_name }}' AS sys_rsrc,
            {% for current_hub in hubs -%}
                {% set v_all_bk_columns = [] -%}
                {% for current_bk in current_hub.bk_columns -%}
                    {% do v_all_bk_columns.append(current_bk.column_name) -%}
                {% endfor -%}
                {{ hkey(source_model_name = source_model_name, list_columns = v_all_bk_columns, hkey_name = current_hub.name) }} {%- if not loop.last %},{% endif %}
            {% endfor %}
            {%- for current_transactional_attribute in transactional_attributes %}
                {% if loop.first %},{% endif %}
                {{ source_model_name }}.{{ current_transactional_attribute.column_name }} AS {{ current_transactional_attribute.business_name }} {%- if not loop.last %},{% endif %}
            {%- endfor %}
  FROM		willibald_psa_sl.v_webshop_kunde
 WHERE		{{ source_model_name }}.sys_cdc != 'D'
   AND		{{ source_model_name }}.kundeid IS NOT NULL
   AND		{{ source_model_name }}.vereinspartnerid IS NOT NULL
 GROUP BY	{{ source_model_name }}.vereinspartnerid, {{ source_model_name }}.kundeid

 {%- endmacro -%}