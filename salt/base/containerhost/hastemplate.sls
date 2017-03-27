has_lxc_alchemy_template:
  file.managed:
    - name: /usr/share/lxc/templates/lxc-ubuntu-alchemy
    - source: salt://containerhost/files/lxc-ubuntu-alchemy
    - template: jinja
    - user: root
    - mode: 755
