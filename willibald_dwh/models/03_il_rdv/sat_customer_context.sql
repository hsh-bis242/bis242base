{%- set yaml_metadata -%}

source_model_name: v_webshop_kunde
parent_ensemble:
  name: hub_customer
  bk_columns:
    - column_name: kundeid
      business_name: customer_id
context_columns:
  - column_name: vorname
    business_name: firstname
  - column_name: name
    business_name: lastname
  - column_name: geschlecht
    business_name: gender
  - column_name: geburtsdatum
    business_name: birthdate
  - column_name: telefon
    business_name: phonenumber
  - column_name: mobil
    business_name: mobilenumber
  - column_name: email
    business_name: emailaddress

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    sat(
        source_model_name = metadata_dict.get('source_model_name'),
        parent_ensemble = metadata_dict.get('parent_ensemble'),
        context_columns = metadata_dict.get('context_columns')
    )
}}