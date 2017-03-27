
slapd_purged:
  pkg.purged:
    - pkgs:
      - slapd
      - ldap-utils

data_removed:
  file.absent:
    - name: {{ pillar.ldap.datadir }}

backup_removed:
  file.absent:
    - name: {{ pillar.ldap.backupdir }}
