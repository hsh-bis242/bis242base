{%- set yaml_metadata -%}

source_model_name: v_webshop_produktkategorie
hubs:
  - name: hub_productcategory
    bk_columns:
      - column_name: katid
        business_name: productcategory_id
  - name: hub_supercategory # pseudo hub: this hub does not exist, it is just a reference on itself
    bk_columns:
      - column_name: oberkatid
        business_name: productcategory_id
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