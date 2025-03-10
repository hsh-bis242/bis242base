SELECT  brdg.hkey_hub_webshoporderitem,
        brdg.sys_loadingid,
        sat_wsoi.quantity,
        sat_wsoi.amount,
        sat_wso.discount,
        brdg.hkey_lnk_webshoporderitem_delivery IS NOT NULL AS is_completely_delivered,
        sat_wso.orderdate,
        sat_wso.requesteddate,
        IFNULL(lnk_wsoi_dlvry.deliverydate, DATE '9999-12-31') AS deliverydate
  FROM  {{ ref("brdg_orderitem_webshop") }} brdg
  JOIN  {{ ref("sat_webshoporderitem_context") }} sat_wsoi
    ON  brdg.hkey_hub_webshoporderitem = sat_wsoi.hkey_hub_webshoporderitem
   AND  brdg.sys_loadingid >= sat_wsoi.sys_loadingid
   AND  brdg.sys_loadingid < sat_wsoi.sys_loadingid_validto
  JOIN  {{ ref("sat_webshoporder_context") }} sat_wso
    ON  brdg.hkey_hub_webshoporder = sat_wso.hkey_hub_webshoporder
   AND  brdg.sys_loadingid >= sat_wso.sys_loadingid
   AND  brdg.sys_loadingid < sat_wso.sys_loadingid_validto
  LEFT JOIN {{ ref("lnk_webshoporderitem_delivery") }} lnk_wsoi_dlvry
    ON  brdg.hkey_lnk_webshoporderitem_delivery = lnk_wsoi_dlvry.hkey_lnk_webshoporderitem_delivery