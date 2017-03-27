bridge-utils:
  pkg.installed: []

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

{{ vnet }}_bridgeport:
  network.managed:
    - name: {{ vnet }}
    - enabled: True
    - type: eth
    - proto: manual

{{ net.link }}_bridge:
  network.managed:
    - name: {{ net.link }}
    - enabled: True
    - ipaddr: {{ net.ipv4 }}
    - type: bridge
    - proto: static
    - bridge: {{ net.link }}
    - delay: 0
    - ports: {{ vnet }}
{%- if net.gateway is defined %}
    - gateway: {{ net.gateway }}
{% endif %}


{% endif -%}

{% endfor %}

