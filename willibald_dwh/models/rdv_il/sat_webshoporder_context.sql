{%- set yaml_metadata -%}

source_model_name: v_webshop_bestellung
parent_ensemble:
  name: hub_webshop_order
  bk_columns:
    - column_name: bestellungid
      business_name: webshoporder_id
context_columns:
  - column_name: bestelldatum
    business_name: orderdate
  - column_name: wunschdatum
    business_name: requesteddate
  - column_name: rabatt
    business_name: discount

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}