{%- set yaml_metadata -%}

source_model_name: v_webshop_vereinspartner
parent_link_name: lnk_association_contact
keys:
  - name: vereinspartnerid
    is_driving_key: true
  - name: kundeidverein
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