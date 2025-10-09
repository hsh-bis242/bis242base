import pandas as pd
import requests

def model(dbt, session):
    
    response = requests.get("https://ferien-api.maxleistner.de/api/v1/2022/")
    response.raise_for_status()  # Ensure we raise an error for bad responses
    vacation_data = response.json()

    df = pd.DataFrame(vacation_data)

    df[["start", "end"]] = df[["start", "end"]].apply(pd.to_datetime)
    df[["year"]] = df[["year"]].apply(pd.to_numeric)

    return df