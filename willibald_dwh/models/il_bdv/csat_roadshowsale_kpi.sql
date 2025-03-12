SELECT  sat_rs_context.hkey_lnk_roadshowsale,
        sat_rs_context.sys_loadingid,
        sat_rs_context.quantity,
        sat_rs_context.amount,
        sat_rs_context.discount,
        sat_rs_context.quantity * sat_rs_context.amount - sat_rs_context.discount AS proceed,
        TRUE AS is_completely_delivered,
        sat_rs_context.saledate AS orderdate,
        sat_rs_context.saledate AS requesteddate,
        sat_rs_context.saledate AS deliverydate,
        0 AS deviation_delivery_request_days,
        NULL AS federalstate_code
  FROM  {{ ref("lsat_roadshowsale_context") }} sat_rs_context
