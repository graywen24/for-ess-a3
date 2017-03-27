{%- for hostname, host in pillar.hosts.iteritems() %}
{%- if host.no_maas is not defined %}
{%- set ip = host.ip4 %}
{%- if host.powerip is defined %}
{%- set ip = host.powerip %}
{%- endif %}
{%- set powerpass = '' %}
{%- if pillar.defaults.maas.powerpass is defined %}
{%- set powerpass = pillar.defaults.maas.powerpass %}
{%- endif %}
create_node {{ hostname }}.{{ pillar.defaults.env }} {{ host.network.manage.mac }} amd64 {{ pillar.defaults.maas.sub }}
power_node {{ pillar.defaults.maas.powertype }} {{ pillar.defaults.maas.powerip }}.{{ ip }} {{ powerpass }}
{%- if host.partitions is defined %}
tag_node {{ host.partitions }}
{%- endif %}
zone_node {{ pillar.defaults.maas.zone }}
commission_node
{% endif -%}
{% endfor %}
