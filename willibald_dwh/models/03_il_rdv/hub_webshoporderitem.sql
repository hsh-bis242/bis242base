{%- set yaml_metadata -%}

business_key_names: 
    - orderitem_id
    - webshoporder_id
source_models:
    - name: v_webshop_position
      bk_columns:
        - bestellungid
        - posid

        

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}