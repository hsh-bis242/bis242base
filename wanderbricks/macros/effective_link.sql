{% macro effective_link(link_name, hkey_ref_table_name, hkey_ref_column_name, loadingid_ref_fullpath) -%}

(
    select  {{ dbt_utils.star(ref("lnk_" + link_name), except=["sys_loadingid", "sys_rsrc"], relation_alias="lnk") }},
            dklsat.sys_loadingid,
            dklsat.sys_loadingid_validto
      from  {{ ref("lnk_" + link_name) }} lnk
      join  {{ ref("lsat_" + link_name + "_dkh") }} dklsat
        on  dklsat.{{ "hkey_lnk_" + link_name }} = lnk.{{ "hkey_lnk_" + link_name }}
) {{ link_name }}
    on  {{ link_name }}.{{ hkey_ref_column_name }} = {{ hkey_ref_table_name }}.{{ hkey_ref_column_name }}
   and  {{ link_name }}.sys_loadingid_validto > {{ loadingid_ref_fullpath }}
   and  {{ link_name }}.sys_loadingid <= {{ loadingid_ref_fullpath }}

{%- endmacro -%}