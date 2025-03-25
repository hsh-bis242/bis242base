SELECT  brdg.hkey_hub_webshoporderitem,
        brdg.sys_loadingid,
        LEAD(brdg.sys_loadingid, 1, 2^31 - 1) OVER (PARTITION BY brdg.hkey_hub_webshoporderitem ORDER BY brdg.sys_loadingid) AS sys_loadingid_validto,
        sat_wsoi.sys_cdc,
        sat_wsoi.quantity,
        sat_wsoi.amount,
        sat_wso.discount,
        sat_wsoi.quantity * sat_wsoi.amount - sat_wso.discount AS proceed,
        brdg.hkey_lnk_webshoporderitem_delivery IS NOT NULL AS is_completely_delivered,
        IFNULL(sat_wso.orderdate, DATE '9999-12-31') AS orderdate,
        IFNULL(sat_wso.requesteddate, DATE '9999-12-31') AS requesteddate,
        IFNULL(lnk_wsoi_dlvry.deliverydate, DATE '9999-12-31') AS deliverydate,
        DATE_DIFF('day', lnk_wsoi_dlvry.deliverydate, sat_wso.requesteddate) AS deviation_delivery_request_days,
        IFNULL(rpf.federal_state_key, 0) as federalstate_key
  FROM  {{ ref("brdg_orderitem_webshop") }} brdg
  JOIN  {{ effective_sat("sat_webshoporderitem_context", "sat_wsoi", "hkey_hub_webshoporderitem", "brdg") }}
  JOIN  {{ effective_sat("sat_webshoporder_context", "sat_wso", "hkey_hub_webshoporder", "brdg") }}
  LEFT JOIN {{ ref("lnk_webshoporderitem_delivery") }} lnk_wsoi_dlvry
    ON  brdg.hkey_lnk_webshoporderitem_delivery = lnk_wsoi_dlvry.hkey_lnk_webshoporderitem_delivery
  LEFT JOIN  {{ effective_sat("sat_deliveryaddress_context", "sat_dlvry", "hkey_hub_deliveryaddress", "brdg") }}
  LEFT JOIN  {{ ref("ref_postalcode_federalstate") }} rpf
    ON  rpf.postalcode = sat_dlvry.postalcode