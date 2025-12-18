{% macro hub(business_key_names, source_models) -%}

with cte_base as (
{% for current_source_model in source_models -%}

select	{{hashcolumn(source_model_name = current_source_model.name, list_columns = current_source_model.bk_columns, hashcolumn_name = "hkey_" + this.name)}},
    	 {{ current_source_model.name }}.sys_loadingid,
    	 '{{ current_source_model.name }}' as sys_rsrc,
    	 {{ loop.index }} as rsrc_order,
        {% for current_bk_column_name, current_bk_name in zip(current_source_model.bk_columns, business_key_names) -%}
            {{ current_source_model.name }}.{{ current_bk_column_name }} as {{ current_bk_name }}{% if not loop.last %},{% endif %}
        {%- endfor %}
   	 from {{ ref(current_source_model.name) }} 
  where {{ current_source_model.name }}.sys_cdc != 'd'

{%- if not loop.last %}
union all
{% endif -%}

{% endfor %}
)
select	hkey_{{ this.name }},
		sys_loadingid,
		sys_rsrc,
        {{ business_key_names | join(', ') }}
  from	cte_base
qualify	row_number() over (partition by {{ business_key_names | join(', ') }} order by sys_loadingid, rsrc_order asc) = 1

{%- endmacro -%}