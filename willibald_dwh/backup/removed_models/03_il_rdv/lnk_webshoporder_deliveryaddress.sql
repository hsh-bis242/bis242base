{%- set yaml_metadata -%}

source_model_name: v_webshop_bestellung
hubs:
  - name: hub_webshoporder
    bk_columns:
      - column_name: bestellungid
        business_name: webshoporder_id
  - name: hub_deliveryaddress
    bk_columns:
      - column_name: allglieferadrid
        business_name: deliveryaddress_id
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