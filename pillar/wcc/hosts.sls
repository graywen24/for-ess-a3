hosts:
  storage-a1:
    ip4: 12
    partitions: partbig
    network:
      manage:
        mac: 18:66:DA:60:B1:C9
      ostack: {}
      storage: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
      - xt_TPROXY
    roles:
      - ostack
  neutron-a1:
    ip4: 13
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:16:1D
      ostack: {}
      storage: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
      - xt_TPROXY
    roles:
      - ostack