
vlan:
  pkg.installed: []

{% set host = salt['alchemy.strip_env'](grains.nodename) %}
{% set config = salt['alchemy.host'](host) %}

{% for key, net in config.network.iteritems() %}
{% if net.link %}

{% set vnet = 'eth2' %}
{% if key == 'ostack' %}
{% set vnet = vnet + '.32' %}
{% elif key == 'storage' %}
{% set vnet = vnet + '.64' %}
{% elif key == 'nhb' %}
{% set vnet = vnet + '.80' %}
{% endif %}

{{ vnet }}_eth:
  network.managed:
    - name: {{ vnet }}
    - ipaddr: {{ net.ipv4 }}
    - enabled: True
    - type: eth
    - proto: static
{%- if net.gateway is defined %}
    - gateway: {{ net.gateway }}
{% endif %}

{% endif -%}

{% endfor %}

