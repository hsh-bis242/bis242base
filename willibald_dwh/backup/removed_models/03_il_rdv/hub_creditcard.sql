{%- set yaml_metadata -%}

business_key_names: 
    - creditcard_number
    - issuer
    - validto
source_models:
    - name: v_webshop_kunde
      bk_columns:
        - kreditkarte
        - kkfirma
        - gueltigbis
    - name: v_roadshow_bestellung
      bk_columns:
        - kreditkarte
        - kkfirma
        - gueltigbis
        

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    hub(
        business_key_names =    metadata_dict.get('business_key_names'),
        source_models =         metadata_dict.get('source_models')
    )
}}