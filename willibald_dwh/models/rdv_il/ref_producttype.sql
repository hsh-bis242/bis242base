{%- set yaml_metadata -%}

source_model_name: v_webshop_ref_produkt_typ
unique_key:
  - column_name: typ
    business_name: producttype
context_columns:
  - column_name: bezeichnung
    business_name: description

{%- endset -%}

{%- set metadata_dict = fromyaml(yaml_metadata) -%}

{{
    reftable(
        source_model_name = metadata_dict.get('source_model_name'),
        unique_key = metadata_dict.get('unique_key'),
        context_columns = metadata_dict.get('context_columns')
    )
}}