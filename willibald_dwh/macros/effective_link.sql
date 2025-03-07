{% macro effective_link(link_name, hkey_ref_table_name, hkey_ref_column_name, loadingid_ref_fullpath) -%}

(
    SELECT  lnk.{{ "hkey_lnk_" + link_name }},
            {{ dbt_utils.star(ref("lnk_" + link_name), except=["hkey_lnk_" + link_name, "sys_loadingid", "sys_rsrc"]) }},
            dklsat.sys_loadingid,
            dklsat.sys_loadingid_validto
      FROM  {{ ref("lnk_" + link_name) }} lnk
      JOIN  {{ ref("lsat_" + link_name + "_dkh") }} dklsat
        ON  dklsat.{{ "hkey_lnk_" + link_name }} = lnk.{{ "hkey_lnk_" + link_name }}
) {{ link_name }}
    ON  {{ link_name }}.{{ hkey_ref_column_name }} = {{ hkey_ref_table_name }}.{{ hkey_ref_column_name }}
   AND  {{ link_name }}.sys_loadingid_validto > {{ loadingid_ref_fullpath }}
   AND  {{ link_name }}.sys_loadingid <= {{ loadingid_ref_fullpath }}

{%- endmacro -%}