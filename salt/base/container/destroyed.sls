{% set container = salt['pillar.get']('container', 'container_not_set') %}
{% set config = salt['alchemy.container'](container) %}

{{ container }}_absent:
  lxc.absent:
    - name: {{ container }}
    - stop: true

