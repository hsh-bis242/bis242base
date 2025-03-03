{%- set yaml_metadata -%}

source_model_name: v_webshop_kunde
parent_link_name: lnk_customer_creditcard
keys:
  - name: kundeid
    is_driving_key: true
  - name: kreditkarte
    is_driving_key: false   
  - name: kkfirma
    is_driving_key: false   
  - name: gueltigbis
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