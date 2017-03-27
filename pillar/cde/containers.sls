containers:
  maas-a1:
    target: ess-a3
    ip4: 100
    network:
      manage:
        gateway: 10.3.50.1
    roles:
      - cde_bootstrap
      - maas
    lxcconf:
      lxc.cgroup.devices.allow:
        loopdevices: "b 7:* rwm" # Maas needs loop devices for image import
        loopcontrol: "c 10:237 rwm" # and access to the loop-control device
      lxc.aa_profile: "unconfined" # and actually allow mounting loops
  repo-a1:
    target: ess-a3
    ip4: 101
    network:
      manage:
        gateway: 10.3.50.1
    mount:
      repo:
        local: /var/storage/{0}/repos
        remote: var/www/repos
    roles:
      - cde_bootstrap
      - repo
  saltmaster-a1:
    target: ess-a3
    ip4: 102
    network:
      manage: {}
    roles:
      - cde_bootstrap
      - saltmaster
  micros-a1:
    target: ess-a3
    ip4: 103
    network:
      manage: {}
    roles:
      - cde_bootstrap
      - dns
      - dhcp
  micros-a2:
    target: ess-a4
    ip4: 104
    network:
      manage: {}
    roles:
      - dns
  lam-a1:
    target: ess-a3
    ip4: 105
    network:
      manage: {}
    roles:
      - ldapsys
      - ldapmgr
  kibana-a1:
    target: ess-a3
    ip4: 106
    network:
      manage: {}
    roles:
      - kibana
  comm-a1:
    target: ess-a3
    ip4: 107
    network:
      manage:
        gateway: 10.3.50.1
    roles:
      - smarthost
      - smtprelay
      - smsgw
      - twofa
  ldap-a1:
    target: ess-a3
    ip4: 108
    network:
      manage: {}
    roles:
      - ldapsys
      - ldapmaster
  ldap-a2:
    target: ess-a4
    ip4: 111
    network:
      manage: {}
    roles:
      - ldapsys
      - ldapslave
