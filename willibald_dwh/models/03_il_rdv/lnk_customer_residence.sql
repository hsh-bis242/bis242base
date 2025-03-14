{%- set yaml_metadata -%}

source_model_name: v_webshop_wohnort
hubs:
  - name: hub_customer
    bk_columns:
      - column_name: kundeid
        business_name: customer_id
transactional_attributes:
  - column_name: von
    business_name: validfrom
        
{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    link(
        source_model_name =         metadata_dict.get('source_model_name'),
        hubs =                      metadata_dict.get('hubs'),
        transactional_attributes =  metadata_dict.get('transactional_attributes')
    )
}}