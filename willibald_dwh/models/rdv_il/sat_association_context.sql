{%- set yaml_metadata -%}

source_model_name: v_webshop_vereinspartner
parent_ensemble:
  name: hub_customer
  bk_columns:
    - column_name: vereinspartnerid
      business_name: association_id
context_columns:
  - column_name: rabatt1
    business_name: discount1
  - column_name: rabatt2
    business_name: discount2
  - column_name: rabatt3
    business_name: discount3


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}