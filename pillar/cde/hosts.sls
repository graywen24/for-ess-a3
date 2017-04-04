hosts:
  ess-a3:
    no_maas: True
    ip4: 10
    partitions: partbig
    no_maas: True
    network:
      manage:
        mac:18:66:DA:68:AD:5B
    roles:
      - containerhost
      - ntp
  neutron-a1:
    #no_maas: True
    ip4: 11
    partitions: partsmall
    network:
      manage:
        mac: 14:18:77:57:16:1D
    roles:
      - containerhost
      - ntp