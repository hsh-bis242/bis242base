{{ dbt_utils.union_relations(
    relations=[
        ref("brdg_orderitem_webshop"),
        ref("brdg_orderitem_roadshow")
        ]
    ) }}