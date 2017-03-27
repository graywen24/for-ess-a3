{% set container = salt['pillar.get']('container', 'container_not_set') %}
{% set profile = salt['pillar.get']('profile', 'ubuntu') %}
{% set config = salt['alchemy.container'](container) %}
{% set fqdn = config.get('envname') %}

container_available:
  lxc.available:
    - name: {{ container }}

container_create:
  module.run:
    - name: lxc.create
    - m_name: {{ container }}
    - profile: {{ profile }}
    - onchanges:
      - lxc: container_available

minon_id_set:
  file.managed:
  - name: /var/lib/lxc/{{ container }}/rootfs/etc/salt/minion_id
  - contents: {{ fqdn }}
  - makedirs: true

resolv_conf_gone:
  file.absent:
    - name: /var/lib/lxc/{{ container }}/rootfs/etc/resolv.conf

{% set resolver = salt['pillar.get']('lxc.container_profile:{0}:resolver'.format(profile), True) %}
{% if resolver %}
resolv_conf:
  file.managed:
    - name: /var/lib/lxc/{{ container }}/rootfs/etc/resolv.conf
    - source: salt://core/files/resolv.conf
    - template: jinja
    - require:
      - file: resolv_conf_gone
{% endif %}

{% if config.defaultconf is defined %}

include_default_config:
  file.replace:
  - name: /var/lib/lxc/{{ container }}/config
  - pattern: "^lxc.include = /usr/share/lxc/config/.*"
  - repl: lxc.include = /usr/share/lxc/config/{{ config.defaultconf }}

{% endif %}

{% if config.network is defined %}
container_network_conf:
  file.managed:
    - name: /var/lib/lxc/{{ container }}/network.conf
    - source: salt://container/files/network.conf
    - template: jinja
    - user: root
    - mode: 644
    - context:
        network_config: {{ config.network }}
    - onchanges:
      - module: container_create

container_interfaces_conf:
  file.managed:
    - name: /var/lib/lxc/{{ container }}/rootfs/etc/network/interfaces
    - source: salt://container/files/interfaces
    - template: jinja
    - user: root
    - mode: 644
    - context:
        network_config: {{ config.network }}
    - onchanges:
      - module: container_create

{% endif %}

{% if config.lxcconf is defined %}
container_append_conf:
  file.managed:
    - name: /var/lib/lxc/{{ container }}/append.conf
    - source: salt://container/files/append.conf
    - template: jinja
    - user: root
    - mode: 644
    - context:
        append_config: {{ config.lxcconf }}
    - onchanges:
      - module: container_create
{% endif %}

container_fstab:
  file.managed:
    - name: /var/lib/lxc/{{ container }}/fstab
    - source: salt://container/files/fstab
    - template: jinja
    - user: root
    - mode: 644
    - context:
        container: {{ container }}
        {% if config.mount is defined %}
        mount: {{ config.mount }}
        {% endif %}
    - onchanges:
      - module: container_create

{% if config.mount is defined %}
{% for key, mount in config.mount.iteritems() %}
local_dir_{{ mount.local }}:
  file.directory:
    - name: {{ mount.local }}
    - makedirs: true
    - user: root
    - group: root
    - dir_mode: 0775
    - require:
      - file: container_fstab

remote_dir_{{ mount.remote }}:
  file.directory:
    - name: /var/lib/lxc/{{ container }}/rootfs/{{ mount.remote }}
    - makedirs: true
    - user: root
    - group: staff
    - dir_mode: 2775
    - require:
      - file: container_fstab
{% endfor %}
{% endif %}

container_running:
  lxc.running:
    - name: {{ container }}
    - onchanges:
      - module: container_create
    {% if config.net is defined %}
    - require:
      - file: container_network_conf
    {% endif %}

{% if config.bootstrap == 1 %}
container_bootstrap:
  module.run:
    - name: lxc.bootstrap
    - m_name: {{ container }}
    - bootstrap_url: {{ pillar.defaults.salt.url }}
    - require:
      - lxc: container_running
    - onchanges:
      - module: container_create

{% endif %}
