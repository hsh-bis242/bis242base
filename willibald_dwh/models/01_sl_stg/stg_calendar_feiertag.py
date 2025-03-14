import pandas as pd
import requests

def model(dbt, session):

    response = requests.get("https://get.api-feiertage.de?years=2022")
    response.raise_for_status()  # Ensure we raise an error for bad responses
    holiday_data = response.json()

    df = pd.DataFrame(holiday_data["feiertage"])
    df["date"] = df["date"].apply(pd.to_datetime)
    
    boolean_columns = ["all_states", "bw", "by", "be", "bb", "hb", "hh", "he", "mv", "ni", "nw", "rp", "sl", "sn", "st", "sh", "th", "augsburg", "katholisch"]
    df[boolean_columns] = df[boolean_columns].applymap(lambda x: True if x == "1" else False)
    
    return df