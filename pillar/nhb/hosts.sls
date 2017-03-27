hosts:
  compute-a1:
    ip4: 10
    partitions: partsmall
    network:
      manage:
        mac: 44:A8:42:28:C5:0A
      ostack: {}
    roles:
      - ostack
  compute-a2:
    ip4: 11
    partitions: partsmall
    network:
      manage:
        mac: 44:A8:42:28:E8:74
      ostack: {}
    roles:
      - ostack
  ctl-a1:
    ip4: 12
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:8E:50
      ostack: {}
      nhb: {}
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
        mac: 44:A8:42:2E:8F:09
      ostack: {}
      nhb: {}
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
        mac: 44:A8:42:2E:78:76
      ostack: {}
    roles:
      - containerhost
  db-a2:
    ip4: 15
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:71:DA
      ostack: {}
    roles:
      - containerhost
  db-a3:
    ip4: 16
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:8E:20
      ostack: {}
    roles:
      - containerhost
  storage-a1:
    ip4: 17
    partitions: partsmall
    network:
      manage:
        mac: 44:A8:42:2E:83:8B
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a2:
    ip4: 18
    partitions: partsmall
    network:
      manage:
        mac: 44:A8:42:2E:89:0A
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a3:
    ip4: 19
    partitions: partsmall
    network:
      manage:
        mac: 44:A8:42:2E:86:BC
      ostack: {}
      storage: {}
    roles:
      - ostack
  neutron-a1:
    ip4: 20
    network:
      manage:
        mac: B0:83:FE:DD:9A:CA
      ostack: {}
      nhb: {}
    packages:
      - iptables
    roles:
      - ostack
      - neutron
  neutron-a2:
    ip4: 21
    network:
      manage:
        mac: B0:83:FE:DD:99:0E
      ostack: {}
      nhb: {}
    packages:
      - iptables
    roles:
      - ostack
      - neutron
  vneutron-a1:
    target: ctl-a1
    ip4: 40
    partitions: partsmall
    network:
      manage:
        mac: 52:54:02:80:2C:B4
      ostack: {}
      storage: {}
    kvm:
      name: ubu-vneutron-a1
      uuid: 30de3ba6-331e-4b13-9a7e-8f3f4fdc5f81
      vcpu: 2
      memory: 2097152
      disk:
        image: /var/storage/local/images/vneutron-a1.img
        size: 20G
        format: qcow2
      macs:
        ostack: 52:54:02:57:87:9C
        nhb: 52:54:02:1A:78:BD
    roles:
      - ostack
  vneutron-a2:
    target: ctl-a2
    ip4: 41
    partitions: partsmall
    network:
      manage:
        mac: 52:54:02:51:57:DE
      ostack: {}
      storage: {}
    kvm:
      name: ubu-vneutron-a2
      uuid: 7d69db77-99b7-4dde-a656-5d41b818469b
      vcpu: 2
      memory: 2097152
      disk:
        image: /var/storage/local/images/vneutron-a2.img
        size: 20G
        format: qcow2
      macs:
        ostack: 52:54:02:FA:24:5C
        nhb: 52:54:02:AE:89:D4
    roles:
      - ostack
  node-a1:
    ip4: 50
    network:
      manage:
        mac: 52:54:00:7c:8f:fa
      ostack: {}
    roles:
      - containerhost
  compute-a3:
    ip4: 22
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:70:BA
      ostack: {}
    roles:
      - ostack
  compute-a4:
    ip4: 23
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:16:4D
      ostack: {}
    roles:
      - ostack
