{%- set yaml_metadata -%}

source_model_name: v_roadshow_bestellung
hubs:
  - name: hub_product
    bk_columns:
      - column_name: produktid
        business_name: product_id
  - name: hub_association
    bk_columns:
      - column_name: vereinspartnerid
        business_name: association_id
  - name: hub_customer
    bk_columns:
      - column_name: kundeid
        business_name: customer_id
  - name: hub_creditcard 
    bk_columns:
      - column_name: kreditkarte
        business_name: creditcard_id
      - column_name: kkfirma
        business_name: issuer
      - column_name: gueltigbis
        business_name: validto
transactional_attributes:
  - column_name: bestellungid 
    business_name: roadshowsale_id 

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    link(
        source_model_name =         metadata_dict.get('source_model_name'),
        hubs =                      metadata_dict.get('hubs'),
        transactional_attributes =  metadata_dict.get('transactional_attributes')
    )
}}