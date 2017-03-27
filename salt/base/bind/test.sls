

{% set zones = salt['alchemy.zones']() %}
{% for zone, zonedata in zones.iteritems() %}

{{ zone }}_dns:
  file.managed:
  - name: /tmp/db.{{ zone }}
  - source: salt://dns/files/template/zone.tpl
  - template: jinja
  - context:
      domain: {{ zone }}
{%- for nodes, nodesdata in zonedata.nodes.iteritems() %}
      {{ nodes }}:
{%- for node, ipdata in nodesdata.iteritems() %}
        {{node}}: {{ ipdata.ip }}
{%- endfor %}
{%- endfor %}

{{ zonedata.reverse }}_dns_reverse:
  file.managed:
  - name: /tmp/db.{{ zonedata.reverse }}
  - source: salt://dns/files/template/revzone.tpl
  - template: jinja
  - context:
      domain: {{ zone }}
{%- for nodes, nodesdata in zonedata.nodes.iteritems() %}
      {{ nodes }}:
{%- for node, ipdata in nodesdata.iteritems() %}
        {{node}}: {{ ipdata.revip }}
{%- endfor %}
{%- endfor %}


{% endfor %}