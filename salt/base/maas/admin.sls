create_admin:
  cmd.script:
    - source: salt://maas/files/createadmin.sh
    - env:
      - MAASADMIN: {{ pillar.defaults.maas.user }}
      - MAASPASS: {{ pillar.defaults.maas.pass }}
      - MAASEMAIL: {{ pillar.defaults.maas.email }}
