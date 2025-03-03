{%- set yaml_metadata -%}

business_key_names: 
    - deliveryservice_id
source_models:
    - name: v_webshop_lieferdienst
      bk_columns:
        - lieferdienstid
    - name: v_webshop_lieferung
      bk_columns:
        - lieferdienstid

        

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}