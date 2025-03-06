WITH cte_lnk_cust_cc AS
(
SELECT  lnk_cust_cc.hkey_hub_creditcard,
        lnk_cust_cc.hkey_hub_customer,
        lnk_cust_cc.hkey_lnk_customer_creditcard,
        dklsat_cust_cc.sys_loadingid,
        dklsat_cust_cc.sys_loadingid_validto
  FROM  {{ ref("lnk_customer_creditcard") }} lnk_cust_cc
  JOIN  {{ ref("lsat_customer_creditcard_dkh") }} dklsat_cust_cc
    ON  dklsat_cust_cc.hkey_lnk_customer_creditcard = lnk_cust_cc.hkey_lnk_customer_creditcard
)
SELECT      lh.loadingts AS sys_loadingts,
            sat_rs_context.sys_loadingid,
            sat_rs_context.hkey_lnk_roadshowsale,
            NULL AS hkey_hub_webshoporderitem,
    		    lnk_rs.roadshowsale_id,
			      COALESCE(hub_cc_cust.hkey_hub_customer, hub_cust.hkey_hub_customer) AS hkey_hub_customer,
            COALESCE(hub_cc_cust.customer_id, hub_cust.customer_id) AS customer_id
  FROM		  {{ ref("loading_history") }} lh
  JOIN      {{ ref("lsat_roadshowsale_context") }} sat_rs_context
    ON      lh.loadingid >= sat_rs_context.sys_loadingid
  JOIN      {{ ref("lnk_roadshowsale") }}	lnk_rs
    ON      lnk_rs.hkey_lnk_roadshowsale = sat_rs_context.hkey_lnk_roadshowsale
  LEFT JOIN	cte_lnk_cust_cc lnk_cust_cc
    ON		  lnk_cust_cc.hkey_hub_creditcard = lnk_rs.hkey_hub_creditcard
   AND      IFNULL(lnk_cust_cc.sys_loadingid_validto, 2^31 - 1) > lh.loadingid
   AND      lnk_cust_cc.sys_loadingid <= lh.loadingid
  LEFT JOIN	{{ ref("hub_customer") }} hub_cc_cust
    ON		  hub_cc_cust.hkey_hub_customer  = lnk_cust_cc.hkey_hub_customer
  LEFT JOIN	{{ ref("hub_customer") }} hub_cust
    ON		  hub_cust.hkey_hub_customer = lnk_rs.hkey_hub_customer