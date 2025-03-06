SELECT      lh.loadingts AS sys_loadingts,
            lh.loadingid AS sys_loadingid,
            sat_rs_context.hkey_lnk_roadshowsale,
            NULL AS hkey_hub_webshoporderitem,
    		    lnk_rs.roadshowsale_id,
			      COALESCE(hub_cc_cust.hkey_hub_customer, hub_cust.hkey_hub_customer) AS hkey_hub_customer,
            COALESCE(hub_cc_cust.customer_id, hub_cust.customer_id) AS customer_id
  FROM		  {{ ref("loading_history") }} lh
  JOIN      {{ ref("lsat_roadshowsale_context") }} sat_rs_context
    ON      lh.loadingid <= sat_rs_context.sys_loadingid
  JOIN      {{ ref("lnk_roadshowsale") }}	lnk_rs
    ON      lnk_rs.hkey_lnk_roadshowsale = sat_rs_context.hkey_lnk_roadshowsale
  LEFT JOIN	{{ effective_link("customer_creditcard", "lnk_rs", "hkey_hub_creditcard", "lh.loadingid") }}
  LEFT JOIN	{{ ref("hub_customer") }} hub_cc_cust
    ON		  hub_cc_cust.hkey_hub_customer  = customer_creditcard.hkey_hub_customer
  LEFT JOIN	{{ ref("hub_customer") }} hub_cust
    ON		  hub_cust.hkey_hub_customer = lnk_rs.hkey_hub_customer
  JOIN      {{ ref("hub_product") }} hub_prdct
    ON      hub_prdct.hkey_hub_product = lnk_rs.hkey_hub_product