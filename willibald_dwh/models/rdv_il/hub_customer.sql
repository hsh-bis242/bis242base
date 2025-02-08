{%- set yaml_metadata -%}

business_key_names: 
    - customer_id
source_models:
    - name: v_webshop_kunde
      bk_columns:
        - kundeid
    - name: v_webshop_vereinspartner
      bk_columns:
        - kundeidverein
    - name: v_roadshow_bestellung
      bk_columns:
        - kundeid
    - name: v_webshop_bestellung
      bk_columns:
        - kundeid
    - name: v_webshop_lieferadresse
      bk_columns:
        - kundeid
    - name: v_webshop_wohnort
      bk_columns:
        - kundeid


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}