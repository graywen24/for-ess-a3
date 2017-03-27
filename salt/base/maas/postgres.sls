
pgcluster.maas.region.controller:
  file.managed:
  - name: /etc/postgresql-common/createcluster.conf
  - source: salt://maas/files/db/pg_cluster.maas
  - template: jinja
  - mode: 0600
  - owner: root
  - makedirs: True

postgresql:
  pkg.latest:
  - require:
    - file: pgcluster.maas.region.controller

