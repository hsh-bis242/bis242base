{{ dbt_utils.unpivot(
    ref("ref_dateholiday_wide"),
    cast_to="boolean",
    exclude=["date", "fname"],
    remove=["all_states", "comment", "augsburg", "katholisch"],
    field_name="statecode",
    value_name="is_holiday"
) }}