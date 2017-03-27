include:
  - repo.gpgkey

apache2:
  pkg.installed: []

nodefault:
  file.absent:
    - name: /etc/apache2/sites-enabled/000-default.conf

repoconfig:
  file.managed:
    - name: /etc/apache2/sites-available/alchemy.conf
    - source: salt://repo/files/site.default
    - template: jinja

configactive:
  file.symlink:
    - name: /etc/apache2/sites-enabled/alchemy.conf
    - target: /etc/apache2/sites-available/alchemy.conf

apache2_refresh:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/sites-available/alchemy.conf
      - file: /etc/apache2/sites-enabled/000-default.conf
    - require:
      - pkg: apache2

bootstrap:
  file.managed:
    - name: /var/www/salt/install_salt.sh
    - source: salt://container/files/bootstrap/install_salt.sh
    - makedirs: true

maasfiles:
  file.recurse:
    - name: /var/www/maas
    - source: salt://repo/files/maas
    - clean: True
    - user: root
    - group: root
    - dir_mode: 0775
    - file_mode: 0664
    - include_empty: True
    - makedirs: true

aptly_stable_repo:
  pkgrepo.managed:
    - humanname: AptlyStableRepo
    - name: deb http://repo.cde.1nc/cde/aptly trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/aptly.list

aptly_config:
  file.managed:
    - name: /etc/aptly.conf
    - source: salt://repo/files/aptly.conf

apt-manage:
  file.managed:
    - name: /sbin/apt-manage
    - source: salt://repo/files/apt-manage
    - user: root
    - group: root
    - file_mode: 0755

aptly:
  pkg.installed: []

rsync:
  pkg.installed: []

uefi-trusty:
  file.exists:
    - name: /var/www/repos/aptly/public/cde/ubuntu/dists/trusty/main/uefi

uefi-trusty-updates:
  file.exists:
    - name: /var/www/repos/aptly/public/cde/ubuntu/dists/trusty-updates/main/uefi

uefi-trusty-security:
  file.exists:
    - name: /var/www/repos/aptly/public/cde/ubuntu/dists/trusty-security/main/uefi

