{%- set yaml_metadata -%}

business_key_names: 
    - association_id
source_models:
    - name: v_webshop_vereinspartner
      bk_columns:
        - vereinspartnerid
    - name: v_webshop_kunde
      bk_columns:
        - vereinspartnerid

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}