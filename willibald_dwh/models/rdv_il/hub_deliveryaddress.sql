{%- set yaml_metadata -%}

business_key_names: 
    - deliveryaddress_id
source_models:
    - name: v_webshop_lieferadresse
      bk_columns:
        - lieferadrid
    - name: v_webshop_bestellung
      bk_columns:
        - allglieferadrid
    - name: v_webshop_lieferung
      bk_columns:
        - lieferadrid
    - name: v_webshop_position
      bk_columns:
        - spezlieferadrid

        

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}