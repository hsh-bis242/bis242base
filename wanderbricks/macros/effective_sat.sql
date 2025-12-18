{% macro effective_sat(ref_table_name, ref_table_short_name, hkey_column_name, base_table_short_name, base_table_hkey_column_name = hkey_column_name) -%}

{{ ref(ref_table_name) }} {{ ref_table_short_name }}
    on  {{ ref_table_short_name }}.{{ hkey_column_name }} = {{ base_table_short_name }}.{{ base_table_hkey_column_name }}
   and  {{ ref_table_short_name }}.sys_loadingid <= {{ base_table_short_name }}.sys_loadingid 
   and  {{ ref_table_short_name }}.sys_loadingid_validto > {{ base_table_short_name }}.sys_loadingid
   and  {{ ref_table_short_name }}.sys_cdc <> 'd'

{%- endmacro -%}