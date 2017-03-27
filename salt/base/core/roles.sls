
# ensure minimal roles regarding machine type on the nodes
{% set hostpath = 'hosts:' + grains.host + ':roles' %}
{% set containerpath = 'containers:' + grains.host + ':roles' %}
{% set defaults = salt['pillar.get']('defaults:roles', {}) %}

{% set hostroles = salt['pillar.get'](hostpath, {}) %}
{% set containerroles = salt['pillar.get'](containerpath, {}) %}

roles:
  grains.present:
    - order: 1
    - value:
{%- if salt['grains.get']('virtual_subtype', '') == 'LXC' %}
      - container
{%- elif salt['grains.get']('virtual', '') == 'physical' %}
      - host
      - metal
{%- elif salt['grains.get']('virtual', '') == 'kvm' %}
      - host
      - vm
{% endif %}
{%- if defaults|length() > 0 %}
{%- for role in defaults %}
      - {{ role }}
{%- endfor %}
{%- endif %}
{%- if hostroles|length() > 0 %}
{%- for role in hostroles %}
      - {{ role }}
{%- endfor %}
{%- endif %}
{%- if containerroles|length() > 0 %}
{%- for role in containerroles %}
      - {{ role }}
{%- endfor %}
{% endif %}

