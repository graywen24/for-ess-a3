
include:
  - ldap.common
  - lam.apache

alchemy-ldap-manager:
  pkg.installed: []

system_config:
  file.managed:
  - name: {{ pillar.lam.datadir }}/config/config.cfg
  - source: salt://lam/files/config.cfg
  - template: jinja
  - user: www-data
  - group: www-data

system_install_profiles:
  file.recurse:
  - name: {{ pillar.lam.datadir }}/config/templates/profiles
  - source: salt://lam/files/profiles
  - user: www-data
  - group: www-data
  - makedirs: True
  - clean: True

system_install_pdf:
  file.recurse:
  - name: {{ pillar.lam.datadir }}/config/templates/pdf
  - source: salt://lam/files/pdf
  - user: www-data
  - group: www-data
  - makedirs: True
  - clean: True


{% for fqdn, server in pillar.ldap.servers.iteritems() %}

{{ fqdn }}_profile:
  file.managed:
  - name: {{ pillar.lam.datadir }}/config/{{ server.short }}.conf
  - source: salt://lam/files/profile.conf
  - template: jinja
  - user: www-data
  - group: www-data
  - context:
      serverip: {{ server.ip }}
      servername: {{ fqdn }}
      shortname: {{ server.short }}

{% endfor %}

