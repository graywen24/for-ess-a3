
isc-dhcp-server:
  pkg.latest: []

dhcpd.conf:
  file.managed:
    - name: /etc/dhcp/dhcpd.conf
    - source: salt://dhcpd/files/dhcpd.maas.conf
    - user: root
    - mode: 644

dhcpconfigs:
    file.recurse:
    - name: /etc/dhcp/dhcpd.d
    - source: salt://dhcpd/files/dhcpd.d
    - user: root
    - group: root
    - dir_mode: 755

dhcpd:
  service.running:
    - name: isc-dhcp-server
    - sig: dhcpd
    - watch:
      - file: dhcpd.conf
      - file: dhcpconfigs
