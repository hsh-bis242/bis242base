{%- set yaml_metadata -%}

source_model_name: v_webshop_position
parent_ensemble:
  name: hub_webshoporderitem
  bk_columns:
    - column_name: bestellungid
      business_name: orderitem_id
    - column_name: posid
      business_name: webshoporder_id
context_columns:
  - column_name: menge
    business_name: quantity
  - column_name: preis
    business_name: amount


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}