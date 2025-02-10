{%- set yaml_metadata -%}

source_model_name: v_roadshow_bestellung
parent_ensemble:
   name: hub_product
    bk_columns:
      - column_name: produktid
        business_name: product_id
   name: hub_association
    bk_columns:
      - column_name: vereinspartnerid
        business_name: association_id
   name: hub_customer
    bk_columns:
      - column_name: kundeid
        business_name: customer_id
   name: hub_creditcard  
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
context_columns:
  - column_name: kaufdatum
    business_name: saledate
  - column_name: menge
    business_name: amount
  - column_name: preis
    business_name: price
  - column_name: rabatt
    business_name: discount


{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}