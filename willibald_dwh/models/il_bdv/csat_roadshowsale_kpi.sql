SELECT  sat_rs_context.hkey_lnk_roadshowsale,
        sat_rs_context.sys_loadingid,
        sat_rs_context.quantity,
        sat_rs_context.amount,
        sat_rs_context.discount,
        TRUE AS is_completely_delivered,
        sat_rs_context.saledate AS orderdate,
        sat_rs_context.saledate AS requesteddate,
        sat_rs_context.saledate AS deliverydate
  FROM  {{ ref("lsat_roadshowsale_context") }} sat_rs_context
