{%- set workspace = salt['grains.get']('workspace', 'NONE') %}

postfix:
  pkg.latest: []

postfix_configure:
  file.managed:
  - name: /etc/postfix/main.cf
  - source: salt://smarthost/files/main.cf
  - template: jinja
  - context:
      workspace: {{ workspace }}

postfix_reloaded:
  service.running:
  - name: postfix
  - watch:
    - file: postfix_configure

{%- if workspace == 'bbox' %}
postfix_catch_all:
  file.managed:
  - name: /etc/postfix/catch_all
  - contents: /^.*$/ ubuntu
{%- endif %}
