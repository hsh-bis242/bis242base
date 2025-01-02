# bis242base
This is the base repository for the practical part of lecture BIS-242

The students are adviced to fork this repository and use it to implement their own elt processes for analyzing [willibald sale data](https://github.com/ddvug/Willibald-Data).

# Installation Instructions
1. Fork this repository to your groups repository
2. Clone your repository to you (local) dev environment
3. Set up a (virtual) dbt environment. This environment needs the requirements.txt to be installed.
4. Execute this:

```
dbt deps
dbt debug
dbt seed
dbt run
```
