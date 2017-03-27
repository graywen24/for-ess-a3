
pre_salt_repo:
  file.absent:
    - name: /etc/apt/sources.list.d/saltstack.list

pre_alchemy_repo:
  file.absent:
    - name: /etc/apt/sources.list.d/alchemy.sources.list

ubuntu_repo:
  file.managed:
    - name: /etc/apt/sources.list
    - source: salt://core/files/apt/sources.list

salt_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/salt.list
    - source: salt://core/files/apt/salt.list
    - require:
      - file: pre_salt_repo

alchemy_repo:
  file.managed:
    - name: /etc/apt/sources.list.d/alchemy.list
    - source: salt://core/files/apt/alchemy.list
    - require:
      - file: pre_alchemy_repo

apt_update:
  cmd.run:
    - name: apt-get -qq update
    - watch:
      - file: ubuntu_repo
      - file: salt_repo
      - file: alchemy_repo

norecommends:
  file.managed:
    - name: /etc/apt/apt.conf.d/02recommends
    - source: salt://core/files/apt/02recommends
