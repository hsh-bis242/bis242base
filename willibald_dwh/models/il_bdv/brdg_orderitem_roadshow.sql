SELECT      lh.loadingts AS sys_loadingts,
            lh.loadingid AS sys_loadingid,
            sat_rs_context.hkey_lnk_roadshowsale,
            NULL AS hkey_hub_webshoporderitem,
    		    lnk_rs.roadshowsale_id,
			      COALESCE(hub_cc_cust.hkey_hub_customer, hub_cust.hkey_hub_customer) AS hkey_hub_customer,
            COALESCE(hub_cc_cust.customer_id, hub_cust.customer_id) AS customer_id,
            hub_prdct.hkey_hub_product,
            hub_prdct.product_id,
            hub_prdctcat.hkey_hub_productcategory,
            hub_prdctcat.productcategory_id,
            hub_prdctcat_sup.hkey_hub_productcategory AS hkey_hub_productsupercategory,
            hub_prdctcat_sup.productcategory_id AS productsupercategory_id
  FROM		  {{ ref("loading_history") }} lh
  JOIN      {{ ref("lsat_roadshowsale_context") }} sat_rs_context
    ON      lh.loadingid >= sat_rs_context.sys_loadingid
   AND      lh.loadingid < sat_rs_context.sys_loadingid_validto
  JOIN      {{ ref("lnk_roadshowsale") }}	lnk_rs
    ON      lnk_rs.hkey_lnk_roadshowsale = sat_rs_context.hkey_lnk_roadshowsale
  LEFT JOIN	{{ effective_link("customer_creditcard", "lnk_rs", "hkey_hub_creditcard", "lh.loadingid") }}
  LEFT JOIN	{{ ref("hub_customer") }} hub_cc_cust
    ON		  hub_cc_cust.hkey_hub_customer  = customer_creditcard.hkey_hub_customer
  LEFT JOIN	{{ ref("hub_customer") }} hub_cust
    ON		  hub_cust.hkey_hub_customer = lnk_rs.hkey_hub_customer
  JOIN      {{ ref("hub_product") }} hub_prdct
    ON      hub_prdct.hkey_hub_product = lnk_rs.hkey_hub_product
  JOIN      {{ effective_link("product_productcategory", "hub_prdct", "hkey_hub_product", "lh.loadingid") }}
  JOIN      {{ ref("hub_productcategory") }} hub_prdctcat
    ON      hub_prdctcat.hkey_hub_productcategory = product_productcategory.hkey_hub_productcategory
  JOIN      {{ effective_link("productcategory_supercategory", "hub_prdctcat", "hkey_hub_productcategory", "lh.loadingid") }}
  JOIN      {{ ref("hub_productcategory") }} hub_prdctcat_sup
    ON      hub_prdctcat_sup.hkey_hub_productcategory = productcategory_supercategory.hkey_hub_productcategory