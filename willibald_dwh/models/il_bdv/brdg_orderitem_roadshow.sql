SELECT      lh.loadingid AS sys_loadingid,
            sat_rs_context.hkey_lnk_roadshowsale,
            lnk_rs.hkey_hub_association,
            CASE WHEN hub_cstmr.customer_id IS NULL THEN customer_creditcard.hkey_hub_customer ELSE hub_cstmr.hkey_hub_customer END AS hkey_hub_customer,
            lnk_rs.hkey_hub_product,
            product_productcategory.hkey_hub_productcategory,
            productcategory_supercategory.hkey_hub_supercategory
  FROM		  {{ ref("loading_history") }} lh
  JOIN      {{ ref("lsat_roadshowsale_context") }} sat_rs_context
    ON      lh.loadingid >= sat_rs_context.sys_loadingid
   AND      lh.loadingid < sat_rs_context.sys_loadingid_validto
  JOIN      {{ ref("lnk_roadshowsale") }}	lnk_rs
    ON      lnk_rs.hkey_lnk_roadshowsale = sat_rs_context.hkey_lnk_roadshowsale
  JOIN      {{ ref("hub_customer") }} hub_cstmr
    ON      hub_cstmr.hkey_hub_customer = lnk_rs.hkey_hub_customer
  JOIN      {{ effective_link("customer_creditcard", "lnk_rs", "hkey_hub_creditcard", "lh.loadingid") }}
  JOIN      {{ effective_link("product_productcategory", "lnk_rs", "hkey_hub_product", "lh.loadingid") }}
  JOIN      {{ effective_link("productcategory_supercategory", "product_productcategory", "hkey_hub_productcategory", "lh.loadingid") }}