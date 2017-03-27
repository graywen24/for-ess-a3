
ca-certificates:
  pkg.installed: []

install_certs:
  file.recurse:
    - name: /usr/local/share/ca-certificates/cas
    - source: salt://core/files/ca
    - makedirs: True
    - clean: True
    - require:
      - pkg: ca-certificates

install_chains:
  file.recurse:
    - name: {{ pillar.system.ssldir }}
    - source: salt://core/files/ca-chains
    - makedirs: True
    - clean: True
    - require:
      - pkg: ca-certificates

update_certs:
  cmd.run:
    - name: update-ca-certificates
    - onchanges:
      - file: install_certs
