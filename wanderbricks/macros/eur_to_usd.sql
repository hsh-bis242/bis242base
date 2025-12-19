{% macro eur_to_usd(amount_eur) %}
    {% set exchange_rate = 1.17 %}
    ({{ amount_eur }} * {{ exchange_rate }}) as {{amount_eur}}_usd
{% endmacro %}
