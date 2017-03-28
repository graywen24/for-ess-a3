hosts:
  compute-a1:
    ip4: 10
    partitions: partsmall
    network:
      manage:
        mac: B0:83:FE:D5:8D:AE
      ostack: {}
    roles:
      - ostack
  compute-a2:
    ip4: 11
    partitions: partsmall
    network:
      manage:
        mac: B0:83:FE:DB:57:28
      ostack: {}
    roles:
      - ostack
  ctl-a1:
    ip4: 12
    partitions: partbig
    network:
      manage:
        mac: 14:18:77:57:70:D2
      ostack: {}
      ha: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
      - xt_TPROXY
    roles:
      - containerhost
  ctl-a2:
    ip4: 13
    partitions: partbig
    network:
      manage:
        mac: 14:18:77:57:73:7C
      ostack: {}
      ha: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
      - xt_TPROXY
    roles:
      - containerhost
  db-a1:
    ip4: 14
    partitions: partbig
    network:
      manage:
        mac: B0:83:FE:DD:98:72
      ostack: {}
    roles:
      - containerhost
  db-a2:
    ip4: 15
    partitions: partbig
    network:
      manage:
        mac: B0:83:FE:CB:E6:AD
      ostack: {}
    roles:
      - containerhost
  db-a3:
    ip4: 16
    partitions: partbig
    network:
      manage:
        mac: B0:83:FE:DD:93:5E
      ostack: {}
    roles:
      - containerhost
  storage-a1:
    ip4: 17
    partitions: partsmall
    network:
      manage:
        mac: B0:83:FE:DD:9E:6B
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a2:
    ip4: 18
    partitions: partsmall
    network:
      manage:
        mac: B0:83:FE:DB:5A:AA
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a3:
    ip4: 19
    partitions: partsmall
    network:
      manage:
        mac: B0:83:FE:DB:58:B7
      ostack: {}
      storage: {}
    roles:
      - ostack
  neutron-a1:
    ip4: 20
    network:
      manage:
        mac: 14:18:77:57:70:EA
      ostack: {}
    packages:
      - iptables
    roles:
      - ostack
      - neutron
  neutron-a2:
    ip4: 21
    network:
      manage:
        mac: 14:18:77:57:15:C8
      ostack: {}
    packages:
      - iptables
    roles:
      - ostack
      - neutron
  compute-a3:
    ip4: 22
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:10:56
      ostack: {}
    roles:
      - ostack
  compute-a4:
    ip4: 23
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:53:42
      ostack: {}
    roles:
      - ostack
