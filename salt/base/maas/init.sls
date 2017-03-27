
include:
  - maas.loopdevice
  - maas.postgres
  - maas.preseeds
  - maas.other

maas_stable_repo:
  pkgrepo.managed:
  - humanname: MaasStableRepo
  - name: deb http://repo.cde.1nc/cde/maas trusty main
  - dist: trusty
  - file: /etc/apt/sources.list.d/maas.list

dbconfig.maas.region.controller:
  file.managed:
  - name: /etc/dbconfig-common/maas-region-controller.conf
  - source: salt://maas/files/db/dbconfig.maas
  - template: jinja
  - mode: 0600
  - owner: root
  - makedirs: True
  - require:
    - pkgrepo: maas_stable_repo

maas_user:
  user.present:
  - name: maas
  - home: /var/storage/maas
  - shell: /bin/false
  - gid_from_name: True
  - system: True
  - createhome: False
  - fullname: "MaaS systemuser"
  - require:
    - sls: maas.postgres

maas_storage_dir:
  file.directory:
  - name: /var/storage/maas
  - user: maas
  - group: maas
  - mode: 755
  - require:
    - user: maas_user

maas_data_mount:
  mount.mounted:
  - name: /var/lib/maas
  - device: /var/storage/maas
  - fstype: none
  - mkmnt: True
  - opts:
    - defaults
    - bind
    - noatime
    - nodiratime
  - require:
    - user: maas_user
    - file: maas_storage_dir

maas:
  pkg.latest:
  - require:
    - pkgrepo: maas_stable_repo
    - mount: maas_data_mount

maas-admin:
  cmd.run:
  - name: maas-region-admin createadmin --username=$USER --password=$PASS --email=$MAIL
  - env:
    - USER: {{ pillar.defaults.maas.user }}
    - PASS: {{ pillar.defaults.maas.pass }}
    - MAIL: {{ pillar.defaults.maas.email }}
  - require:
    - pkg: maas
