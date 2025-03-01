{%- set yaml_metadata -%}

source_model_name: v_webshop_lieferdienst
parent_ensemble:
  name: hub_deliveryservice
  bk_columns:
    - column_name: lieferdienstid
      business_name: deliveryservice_id
context_columns:
  - column_name: name
    business_name: name
  - column_name: telefon
    business_name: phonenumber
  - column_name: fax
    business_name: faxnumber
  - column_name: email
    business_name: emailaddress
  - column_name: strasse
    business_name: street
  - column_name: hausnummer
    business_name: housenumber
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