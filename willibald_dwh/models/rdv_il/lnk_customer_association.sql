{%- set yaml_metadata -%}

source_model_name: v_webshop_kunde
hubs:
  - name: hub_customer
    bk_columns:
      - column_name: kundeid
        business_name: customer_id
  - name: hub_association
    bk_columns:
      - column_name: vereinspartnerid
        business_name: association_id
transactional_attributes: []
    
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    link(
        source_model_name =         metadata_dict.get('source_model_name'),
        hubs =                      metadata_dict.get('hubs'),
        transactional_attributes =  metadata_dict.get('transactional_attributes')
    )
}}