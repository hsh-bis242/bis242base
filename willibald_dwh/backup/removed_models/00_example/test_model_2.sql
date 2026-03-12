{{ config(materialized = 'view') }}

select *
from {{ ref("test_model") }}
where kkfirma = 'VISA'
