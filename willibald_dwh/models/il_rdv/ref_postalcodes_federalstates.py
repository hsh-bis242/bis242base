import pandas as pd
import requests

def model(dbt, session):

    postalcodes = dbt.ref("ref_uniquepostalcodes").to_df()

    # iterate through all postal codes in the list and get the federal state
    postalcodes["federal_state_key"] = postalcodes["postalcode"].apply(lambda x: get_federal_state_key(str(x)))

    return postalcodes

def get_federal_state_key(postalcode):
    response = requests.get("https://openplzapi.org/de/Localities?postalCode=" + postalcode)
    response.raise_for_status()  # Ensure we raise an error for bad responses
    locality = response.json()

    return locality[0]["federalState"]["key"]