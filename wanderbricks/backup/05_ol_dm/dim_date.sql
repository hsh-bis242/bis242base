with cte_fsc as (
  select  key,
          federalstate_code,
          federalstate_name
    from  {{ ref("federalstatecode") }}
   union all
  select  0 as key,
          'xx' as federalstate_code,
          'unbekannt' as federalstate_name
),
cte_date as (
  select        {{ dbt_utils.star(ref("ref_date")) }},
                fsc.key as federalstate_key,
                fsc.federalstate_code,
                fsc.federalstate_name
    from        {{ ref("ref_date") }} dt
   cross join   cte_fsc fsc
)

select      {{hashcolumn(source_model_name = "dt", list_columns = ["date_day", "federalstate_key"], hashcolumn_name = "hkey_" + this.name)}},
            dt.*,
            ifnull(hol.fname,'') as holiday_name,
            ifnull(hol.is_holiday, false) as is_holiday,
            ifnull(vac.name,'') as vacation_name,
            not vac.name is null as is_vacation
  from      cte_date dt
  left join {{ ref("ref_dateholiday") }} hol
    on      hol.date = dt.date_day
   and      upper(hol.statecode) = dt.federalstate_code
  left join {{ ref("ref_datevacation") }} vac
    on      dt.date_day >= vac.start and dt.date_day < vac.end
   and      vac.statecode = dt.federalstate_code

 union all

select  {{hashcolumn(source_model_name = "dt", list_columns = ["date_day", "federalstate_key"], hashcolumn_name = "hkey_" + this.name)}},
        dt.*,
        null as holiday_name,
        null as is_holiday,
        null as vacation_name,
        null as is_vacation
  from  (
          select  date '9999-12-31' as date_day,
                  null as prior_date_day,
                  null as next_date_day,
                  null as prior_year_date_day,
                  null as prior_year_over_year_date_day,
                  null as day_of_week,
                  null as day_of_week_iso,
                  null as day_of_week_name,
                  null as day_of_week_name_short,
                  null as day_of_month,
                  null as day_of_year,
                  null as week_start_date,
                  null as week_end_date,
                  null as prior_year_week_start_date,
                  null as prior_year_week_end_date,
                  null as week_of_year,
                  null as iso_week_start_date,
                  null as iso_week_end_date,
                  null as prior_year_iso_week_start_date,
                  null as prior_year_iso_week_end_date,
                  null as iso_week_of_year,
                  null as prior_year_week_of_year,
                  null as prior_year_iso_week_of_year,
                  null as month_of_year,
                  null as month_name,
                  null as month_name_short,
                  null as month_start_date,
                  null as month_end_date,
                  null as prior_year_month_start_date,
                  null as prior_year_month_end_date,
                  null as quarter_of_year,
                  null as quarter_start_date,
                  null as quarter_end_date,
                  null as year_number,
                  null as year_start_date,
                  null as year_end_date,
                  fsc.key as federalstate_key,
                  fsc.federalstate_code,
                  fsc.federalstate_name
            from  cte_fsc fsc
        ) dt