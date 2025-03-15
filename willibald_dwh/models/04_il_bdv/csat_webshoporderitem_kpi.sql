SELECT  brdg.hkey_hub_webshoporderitem,
        brdg.sys_loadingid,
        sat_wsoi.sys_loadingid_validto,
        sat_wsoi.quantity,
        sat_wsoi.amount,
        sat_wso.discount,
        sat_wsoi.quantity * sat_wsoi.amount - sat_wso.discount AS proceed,
        brdg.hkey_lnk_webshoporderitem_delivery IS NOT NULL AS is_completely_delivered,
        sat_wso.orderdate,
        sat_wso.requesteddate,
        IFNULL(lnk_wsoi_dlvry.deliverydate, DATE '9999-12-31') AS deliverydate,
        DATE_DIFF('day', lnk_wsoi_dlvry.deliverydate, sat_wso.requesteddate) AS deviation_delivery_request_days,
        rpf.federal_state_key as federalstate_key
  FROM  {{ ref("brdg_orderitem_webshop") }} brdg
  JOIN  {{ effective_sat("sat_webshoporderitem_context", "sat_wsoi", "hkey_hub_webshoporderitem", "brdg") }}
  JOIN  {{ effective_sat("sat_webshoporder_context", "sat_wso", "hkey_hub_webshoporder", "brdg") }}
  LEFT JOIN {{ ref("lnk_webshoporderitem_delivery") }} lnk_wsoi_dlvry
    ON  brdg.hkey_lnk_webshoporderitem_delivery = lnk_wsoi_dlvry.hkey_lnk_webshoporderitem_delivery
  JOIN  {{ effective_sat("sat_deliveryaddress_context", "sat_dlvry", "hkey_hub_deliveryaddress", "brdg") }}
  JOIN  {{ ref("ref_postalcode_federalstate") }} rpf
    ON  rpf.postalcode = sat_dlvry.postalcode