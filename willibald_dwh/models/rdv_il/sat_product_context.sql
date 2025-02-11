{%- set yaml_metadata -%}

source_model_name: v_webshop_produkt
parent_ensemble:
  name: hub_product
  bk_columns:
    - column_name: produktid
      business_name: product_id
context_columns:
  - column_name: bezeichnung
    business_name: description
  - column_name: umfang
    business_name: circumference
  - column_name: typ
    business_name: producttype
  - column_name: preis
    business_name: price
  - column_name: pflanzort
    business_name: plantinglocation
  - column_name: pflanzabstand
    business_name: plantingdistance

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}