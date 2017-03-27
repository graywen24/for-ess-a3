

bind9:
  pkg.latest: []

/etc/bind/bind.keys:
  file.exists: []

/etc/bind/rndc.key:
  file.exists: []

configs:
  file.recurse:
    - name: /etc/bind
    - source: salt://bind/files
    - exclude_pat: zones*
    - exclude_pat: template*
    - template: jinja
    - clean: True
    - user: root
    - group: root
    - dir_mode: 0775
    - file_mode: 0644
    - include_empty: True
    - require:
      - file: /etc/bind/bind.keys
      - file: /etc/bind/rndc.key

zones:
  file.recurse:
    - name: /etc/bind/zones
    - source: salt://bind/files/zones
    - clean: True
    - user: root
    - group: root
    - dir_mode: 0775
    - file_mode: 0644
    - include_empty: True

bind9_refresh:
  service.running:
    - name: bind9
    - sig: /usr/sbin/named
    - watch:
      - file: configs
      - file: zones
