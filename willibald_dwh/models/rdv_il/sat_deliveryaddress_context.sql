{%- set yaml_metadata -%}

source_model_name: v_webshop_lieferadresse
parent_ensemble:
  name: hub_deliveryaddress
  bk_columns:
    - column_name: lieferadrid
      business_name: dliveryaddress_id
context_columns:
  - column_name: strasse
    business_name: street
  - column_name: hausnummer
    business_name: housenumber
  - column_name: adresszusatz
    business_name: addresssupplement
  - column_name: plz
    business_name: postcalcode
  - column_name: ort
    business_name: city
  - column_name: land
    business_name: country

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}