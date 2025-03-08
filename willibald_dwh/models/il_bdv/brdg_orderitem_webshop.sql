SELECT  lh.loadingid AS sys_loadingid,
        sat_wsoi.hkey_hub_webshoporderitem,
        webshoporderitem_webshoporder.hkey_hub_webshoporder,
        webshoporderitem_product.hkey_hub_product,
        product_productcategory.hkey_hub_productcategory,
        productcategory_supercategory.hkey_hub_supercategory,
        webshoporderitem_delivery.hkey_lnk_webshoporderitem_delivery,
        webshoporderitem_delivery.hkey_hub_deliveryservice,
        CASE WHEN hub_dlvryaddrss.deliveryaddress_id IS NULL THEN webshoporder_deliveryaddress.hkey_hub_deliveryaddress ELSE hub_dlvryaddrss.hkey_hub_deliveryaddress END AS hkey_hub_deliveryaddress,
        webshoporder_customer.hkey_hub_customer,
        customer_association.hkey_hub_association
  FROM  {{ ref("loading_history") }} lh
  JOIN  {{ ref("sat_webshoporderitem_context") }} sat_wsoi
    ON  lh.loadingid >= sat_wsoi.sys_loadingid
   AND  lh.loadingid < sat_wsoi.sys_loadingid_validto

   -- product
  JOIN  {{ effective_link("webshoporderitem_product", "sat_wsoi", "hkey_hub_webshoporderitem", "lh.loadingid") }}
  JOIN  {{ effective_link("product_productcategory", "webshoporderitem_product", "hkey_hub_product", "lh.loadingid") }}
  JOIN  {{ effective_link("productcategory_supercategory", "product_productcategory", "hkey_hub_productcategory", "lh.loadingid") }}

  -- webshoporder
  JOIN  {{ effective_link("webshoporderitem_webshoporder", "sat_wsoi", "hkey_hub_webshoporderitem", "lh.loadingid") }}
  
  -- deliveryaddress
  JOIN  {{ effective_link("webshoporder_deliveryaddress", "webshoporderitem_webshoporder", "hkey_hub_webshoporder", "lh.loadingid") }}
  JOIN  {{ effective_link("webshoporderitem_deliveryaddress", "sat_wsoi", "hkey_hub_webshoporderitem", "lh.loadingid") }}
  JOIN  {{ ref("hub_deliveryaddress") }} hub_dlvryaddrss
    ON  hub_dlvryaddrss.hkey_hub_deliveryaddress = webshoporderitem_deliveryaddress.hkey_hub_deliveryaddress

  -- customer
  JOIN  {{ effective_link("webshoporder_customer", "webshoporderitem_webshoporder", "hkey_hub_webshoporder", "lh.loadingid") }}
  JOIN  {{ effective_link("customer_association", "webshoporder_customer", "hkey_hub_customer", "lh.loadingid") }}

  -- delivery
  JOIN  {{ effective_link("webshoporderitem_delivery", "sat_wsoi", "hkey_hub_webshoporderitem", "lh.loadingid") }}