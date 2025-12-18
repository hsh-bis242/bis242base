select *
from {{ source("wanderbricks", "employees") }}
