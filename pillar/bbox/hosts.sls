hosts:
  compute-a1:
    ip4: 10
    powerip: 10
    network:
      manage:
        mac: ec:a8:6b:fa:c8:45
      ostack: {}
    roles:
      - ostack
  compute-a2:
    ip4: 11
    powerip: 11
    network:
      manage:
        mac: c0:3f:d5:6f:f3:a0
      ostack: {}
    roles:
      - ostack
  ctl-a1:
    ip4: 12
    powerip: 15
    network:
      manage:
        mac: c0:3f:d5:6e:f9:0e
      ostack: {}
      nhb: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
    roles:
      - containerhost
  ctl-a2:
    ip4: 13
    powerip: 16
    network:
      manage:
        mac: c0:3f:d5:6f:f3:5a
      ostack: {}
      nhb: {}
    packages:
      - vlan
    modules:
      - openvswitch
      - 8021q
      - ip_tables
    roles:
      - containerhost
  db-a1:
    ip4: 14
    powerip: 17
    network:
      manage:
        mac: c0:3f:d5:6f:f3:be
      ostack: {}
    roles:
      - containerhost
  db-a2:
    ip4: 15
    powerip: 18
    network:
      manage:
        mac: c0:3f:d5:6f:f4:13
      ostack: {}
    roles:
      - containerhost
  db-a3:
    ip4: 16
    powerip: 19
    network:
      manage:
        mac: c0:3f:d5:6f:f3:76
      ostack: {}
    roles:
      - containerhost
  storage-a1:
    ip4: 17
    powerip: 12
    network:
      manage:
        mac: c0:3f:d5:6f:f2:ce
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a2:
    ip4: 18
    powerip: 13
    network:
      manage:
        mac: c0:3f:d5:6f:f3:05
      ostack: {}
      storage: {}
    roles:
      - ostack
  storage-a3:
    ip4: 19
    powerip: 14
    network:
      manage:
        mac: c0:3f:d5:6f:f3:5d
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
