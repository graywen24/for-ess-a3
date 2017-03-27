has_lxc_alchemy_configs:
  file.managed:
    - name: /usr/share/lxc/config/ubuntu.lowsec.conf
    - source: salt://containerhost/files/lxcconf/ubuntu.lowsec.conf
    - user: root
    - mode: 644
