{% macro reftable(source_model_name, unique_key, context_columns) -%}

{% set v_all_columns = unique_key + context_columns -%}

with cte_ref_data as (
    select  {{ source_model_name }}.sys_loadingid,
            lead({{ source_model_name }}.sys_loadingid) over (partition by {{ unique_key | map(attribute="column_name") | join(", ") }} order by {{ source_model_name }}.sys_loadingid asc) as sys_loadingid_validto,
            {{ source_model_name }}.sys_cdc,
            {{ hashcolumn(source_model_name = source_model_name, list_columns = context_columns | map(attribute="column_name"), hashcolumn_name = "sys_checksum") }},
            {% for current_column in v_all_columns -%}
                {{ source_model_name }}.{{ current_column.column_name }} as {{ current_column.business_name }}{% if not loop.last %},{% endif %}
            {% endfor -%}
      from  {{ ref(source_model_name) }}
)
 select sys_loadingid,
        sys_loadingid_validto,
        sys_cdc,
        sys_checksum,
        {% for current_column in v_all_columns -%}
            {{ current_column.business_name }}{% if not loop.last %},{% endif %}
        {% endfor -%}
   from cte_ref_data
  where sys_cdc != 'd'
qualify coalesce(lag(sys_checksum) over (partition by {{ unique_key | map(attribute="business_name") | join(", ") }} order by sys_loadingid), '') <> sys_checksum

{%- endmacro -%}