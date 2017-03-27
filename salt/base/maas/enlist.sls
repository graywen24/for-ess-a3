
pwgen:
  pkg.installed: []

create_enlist_meta_script:
  file.managed:
  - name: /root/enlist.{{ pillar.defaults.env }}.sh
  - source: salt://maas/files/scripts/enlist.sh
  - mode: 0775
  - user: root
  - group: root
  - template: jinja

create_enlist_script:
  file.managed:
  - name: /root/enlisthosts.{{ pillar.defaults.env }}.sh
  - source: salt://maas/files/scripts/enlisthosts.sh
  - mode: 0775
  - user: root
  - group: root
  - template: jinja
