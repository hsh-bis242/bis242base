WITH cte_date AS (
  SELECT        {{ dbt_utils.star(ref("ref_date")) }},
                fsc.key AS federalstate_key,
                fsc.federalstate_code,
                fsc.federalstate_name
    FROM        {{ ref("ref_date") }} dt
   CROSS JOIN   {{ ref("federalstatecode") }} fsc
)

SELECT      dt.*,
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