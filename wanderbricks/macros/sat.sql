{% macro sat(source_model_name, parent_ensemble, context_columns) -%}

{% set v_all_bk_columns = [] -%}
{% for current_bk in parent_ensemble.bk_columns -%}
    {% do v_all_bk_columns.append(current_bk.column_name) -%}
{% endfor -%}

with cte_sat_data as (
    select  {{ hashcolumn(source_model_name = source_model_name, list_columns = v_all_bk_columns, hashcolumn_name = "hkey_" + parent_ensemble.name) }},
            {{ source_model_name }}.sys_loadingid,
            {{ source_model_name }}.sys_cdc,
            {{ hashcolumn(source_model_name = source_model_name, list_columns = context_columns | map(attribute='column_name'), hashcolumn_name = "sys_checksum") }},
            {% for current_context_column in context_columns -%}
                {{ source_model_name }}.{{ current_context_column.column_name }} as {{ current_context_column.business_name }}{% if not loop.last %},{% endif %}
            {% endfor -%}
      from  {{ ref(source_model_name) }}
),
cte_sat_format as (
 select {{ "hkey_" + parent_ensemble.name }},
        sys_loadingid,
        sys_cdc,
        sys_checksum,
        {% for current_context_column in context_columns -%}
            {{ current_context_column.business_name }}{% if not loop.last %},{% endif %}
        {% endfor -%}
   from cte_sat_data
qualify coalesce(lag(sys_checksum) over (partition by {{ "hkey_" + parent_ensemble.name }} order by sys_loadingid), '') <> sys_checksum
)
select  *,
        lead(sys_loadingid, 1, 2^31 - 1) over (partition by {{ "hkey_" + parent_ensemble.name }} order by sys_loadingid) as sys_loadingid_validto
  from  cte_sat_format

{%- endmacro -%}