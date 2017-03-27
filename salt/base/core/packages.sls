ntpdate:
  pkg.purged: []

htop:
  pkg.latest: []

wget:
  pkg.latest: []

{% if 'ostack' in grains.roles %}

ostack-packages:
  pkg.latest:
  - pkgs:
    - dbus
    - curl
    - rsyslog-gnutls

{% endif %}


{%- set nodepath = "hosts:%s:packages"|format(grains.nodename) %}
{%- set packages = salt['pillar.get'](nodepath, []) %}
{%- for package in packages %}

{{ package }}_installed:
  pkg.latest:
  - name: {{ package }}

{%- endfor %}

{%- set nodepath = "containers:%s:packages"|format(grains.nodename) %}
{%- set packages = salt['pillar.get'](nodepath, []) %}
{%- for package in packages %}

{{ package }}_installed:
  pkg.latest:
  - name: {{ package }}

{%- endfor %}
