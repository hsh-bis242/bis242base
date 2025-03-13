WITH cte_postalcodes AS (
    {{ dbt_utils.union_relations(
        relations=[ref("lsat_customer_residence_context"), ref("sat_deliveryaddress_context"), ref("sat_deliveryservice_context")],
        include=["postalcode"]
    ) }}
)
SELECT
    DISTINCT postalcode
FROM cte_postalcodes
WHERE postalcode IS NOT NULL