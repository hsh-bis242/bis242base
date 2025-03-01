{%- set yaml_metadata -%}

source_model_name: v_webshop_bestellung
parent_link_name: lnk_webshoporder_customer
keys:
  - name: bestellungid
    is_driving_key: true
  - name: kundeid
    is_driving_key: false    
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    dk_lsat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_link_name =  metadata_dict.get('parent_link_name'),
        keys =              metadata_dict.get('keys')
    )
}}