{%- set yaml_metadata -%}

business_key_names: 
    - productcategory_id
source_models:
    - name: v_webshop_produktkategorie
      bk_columns:
        - katid
    - name: v_webshop_produktkategorie
      bk_columns:
        - oberkatid
    - name: v_webshop_produkt
      bk_columns:
        - katid

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}