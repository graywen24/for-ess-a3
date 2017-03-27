base:
  '*':
    - core
    - debug.unlocked
    - sshd
  roles:host:
    - match: grain
    - core.grub
    - ntp
  roles:containerhost:
    - match: grain
    - containerhost
  'repo-a?.cde.1nc':
    - repo
  'micros-a1.cde.1nc':
    - bind
    - dhcpd
  'micros-a2.cde.1nc':
    - bind
  'ldap-a?.cde.1nc':
    - ldap.server
    - ldap.server.initial
  'lam-a?.cde.1nc':
    - lam
  'cmd-a?.nhb.1nc':
    - juju.basics
    - juju.user
    - juju.debugcharm
  maas-a1.cde.1nc:
    - maas


