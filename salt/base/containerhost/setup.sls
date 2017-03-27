
lxc-net-default:
  file.managed:
    - name: /etc/default/lxc-net
    - source: salt://containerhost/files/lxc-net.default

lxc_pkgs:
  pkg.installed:
    - pkgs:
      - bridge-utils
      - iptables
      - debootstrap
      - lxc
      - lxc-templates
    - install_recommends: False
    - reload_modules: True
    - require:
      - file: lxc-net-default

conf_sysctl:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

