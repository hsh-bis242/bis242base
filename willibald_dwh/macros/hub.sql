{% macro hub(business_key_names, source_models) -%}

WITH cte_base AS (
{% for current_source_model in source_models -%}

SELECT	sha256(
            {% for current_bk_column_name in current_source_model.bk_columns -%}
                trim({{ current_source_model.name }}.{{ current_bk_column_name }}::VARCHAR) {% if not loop.last %} || '|' || {% endif %}
            {%- endfor %}
        ) AS hkey_{{ this.name }},
	    {{ current_source_model.name }}.sys_loadingid,
	    '{{ current_source_model.name }}' AS sys_rsrc,
	    {{ loop.index }} AS rsrc_order,
        {% for current_bk_column_name, current_bk_name in zip(current_source_model.bk_columns, business_key_names) -%}
            {{ current_source_model.name }}.{{ current_bk_column_name }} AS {{ current_bk_name }}{% if not loop.last %},{% endif %}
        {%- endfor %}
	   FROM {{ ref(current_source_model.name) }} 
	  WHERE {{ current_source_model.name }}.sys_cdc != 'D'

{%- if not loop.last %}
UNION ALL
{% endif -%}

{% endfor %}
)
SELECT	hkey_{{ this.name }},
		sys_loadingid,
		sys_rsrc,
        {{ business_key_names | join(', ') }}
  FROM	cte_base
QUALIFY	row_number() OVER (PARTITION BY {{ business_key_names | join(', ') }} ORDER BY sys_loadingid, rsrc_order ASC) = 1

{%- endmacro -%}