{%- set yaml_metadata -%}

source_model_name: v_webshop_href_termintreue
unique_key:
  - column_name: "\"Anzahl Tage von\""
    business_name: number_of_days_from
context_columns:
  - column_name: "\"Anzahl Tage bis\""
    business_name: number_of_days_to
  - column_name: bezeichnung
    business_name: description
  - column_name: bewertung
    business_name: rating

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    reftable(
        source_model_name = metadata_dict.get('source_model_name'),
        unique_key = metadata_dict.get('unique_key'),
        context_columns = metadata_dict.get('context_columns')
    )
}}