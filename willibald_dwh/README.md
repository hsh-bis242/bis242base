Welcome to the bis-242 dbt project.

## Using the willibald base project

To get up and running run following commands:
- dbt deps
- dbt debug
- dbt seed
- dbt run
- dbt test

### How does the willibald data gets loaded to the database?

Originally the willibald data comes within three loading periods. We persisted these three periods in a very basic persistent
staging scheme, which persists as seeds within this repository. Every line of the original data files get three additional columns in this:
- sys_loadingid (which points to the loading_history table, which is also stored in this repository as a seed)
- sys_cdc (a change data capture indicator with the following features: *I*nserted, *C*hanged or *D*eleted)
- sys_checksum (is a checksum over the complete columns, except for the primary key)

From this point on all the data vault loading is implemented as proposed by [Roelant Vos](https://www.roelantvos.com/). The pattern are kept as simple as possible, for your convenience.

A first loading step is to calculate a current value flag in a view on the persisted staging tables. Therefore a macro "psa_view" is created, which depends on a new meta attribute called unique_key attached to the psa seed tables (you can see the definitions within psa_sl_properties.yml).

### How is the data vault of this project implemented?

Data vault consists of three different entities. Hub, Links and Satellite. There is a macro for everyone of these entities.

Please consider it a bad habbit to write all the data vault loading functionality from ground up. There are at least two very advanced packages for loading data to a data vault, that should be your first choice. We have refrained from using these packages for educating reasons.

### How are references validatet?

Every link comes with his own driving key link satellite, which marks it's validity on all the loadingids. These LSATs have to be joined to get the correct reference history.

## Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Learn about this project's structure [on the slides](https://github.com/hsh-bis242/hsh-bi-class)
