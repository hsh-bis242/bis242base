{%- set yaml_metadata -%}

source_model_name: v_webshop_produktkategorie
parent_ensemble:
  name: hub_productcategory
  bk_columns:
    - column_name: katid
      business_name: productcategory_id
context_columns:
  - column_name: name
    business_name: name

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}