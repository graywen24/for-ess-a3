
hostsfile:
  file.managed:
    - name: /etc/hosts
    - source: salt://core/files/hosts
    - template: jinja

