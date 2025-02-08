{%- set yaml_metadata -%}

business_key_names: 
    - product_id
source_models:
    - name: v_webshop_produkt
      bk_columns:
        - produktid
    - name: v_webshop_position
      bk_columns:
        - produktid
    - name: v_webshop_produkt
      bk_columns:
        - produktid

        

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}