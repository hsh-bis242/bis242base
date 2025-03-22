WITH cte_fsc AS (
  SELECT  key,
          federalstate_code,
          federalstate_name
    FROM  {{ ref("federalstatecode") }}
   UNION ALL
  SELECT  0 AS key,
          'XX' AS federalstate_code,
          'Unbekannt' AS federalstate_name
),
cte_date AS (
  SELECT        {{ dbt_utils.star(ref("ref_date")) }},
                fsc.key AS federalstate_key,
                fsc.federalstate_code,
                fsc.federalstate_name
    FROM        {{ ref("ref_date") }} dt
   CROSS JOIN   cte_fsc fsc
)

SELECT      {{hashcolumn(source_model_name = "dt", list_columns = ["date_day", "federalstate_key"], hashcolumn_name = "hkey_" + this.name)}},
            dt.*,
            IFNULL(hol.fname,'') as holiday_name,
            IFNULL(hol.is_holiday, FALSE) as is_holiday,
            IFNULL(vac.name,'') as vacation_name,
            NOT vac.name IS NULL AS is_vacation
  FROM      cte_date dt
  LEFT JOIN {{ ref("ref_dateholiday") }} hol
    ON      hol.date = dt.date_day
   AND      UPPER(hol.statecode) = dt.federalstate_code
  LEFT JOIN {{ ref("ref_datevacation") }} vac
    ON      dt.date_day >= vac.start AND dt.date_day < vac.end
   AND      vac.statecode = dt.federalstate_code

 UNION ALL

SELECT  {{hashcolumn(source_model_name = "dt", list_columns = ["date_day", "federalstate_key"], hashcolumn_name = "hkey_" + this.name)}},
        dt.*,
        NULL AS holiday_name,
        NULL AS is_holiday,
        NULL AS vacation_name,
        NULL AS is_vacation
  FROM  (
          SELECT  DATE '9999-12-31' AS date_day,
                  NULL AS prior_date_day,
                  NULL AS next_date_day,
                  NULL AS prior_year_date_day,
                  NULL AS prior_year_over_year_date_day,
                  NULL AS day_of_week,
                  NULL AS day_of_week_iso,
                  NULL AS day_of_week_name,
                  NULL AS day_of_week_name_short,
                  NULL AS day_of_month,
                  NULL AS day_of_year,
                  NULL AS week_start_date,
                  NULL AS week_end_date,
                  NULL AS prior_year_week_start_date,
                  NULL AS prior_year_week_end_date,
                  NULL AS week_of_year,
                  NULL AS iso_week_start_date,
                  NULL AS iso_week_end_date,
                  NULL AS prior_year_iso_week_start_date,
                  NULL AS prior_year_iso_week_end_date,
                  NULL AS iso_week_of_year,
                  NULL AS prior_year_week_of_year,
                  NULL AS prior_year_iso_week_of_year,
                  NULL AS month_of_year,
                  NULL AS month_name,
                  NULL AS month_name_short,
                  NULL AS month_start_date,
                  NULL AS month_end_date,
                  NULL AS prior_year_month_start_date,
                  NULL AS prior_year_month_end_date,
                  NULL AS quarter_of_year,
                  NULL AS quarter_start_date,
                  NULL AS quarter_end_date,
                  NULL AS year_number,
                  NULL AS year_start_date,
                  NULL AS year_end_date,
                  fsc.key AS federalstate_key,
                  fsc.federalstate_code,
                  fsc.federalstate_name
            FROM  cte_fsc fsc
        ) dt