{%- set yaml_metadata -%}

source_model_name: v_webshop_position
parent_link_name: lnk_webshoporderitem_product
keys:
  - name: bestellungid
    is_driving_key: true    
  - name: posid
    is_driving_key: true  
  - name: produktid
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