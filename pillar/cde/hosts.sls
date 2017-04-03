hosts:
  ess-a3:
    ip4: 10
    partitions: partbig
    no_maas: True
    network:
      manage:
        mac:18:66:DA:68:AD:5B
    roles:
      - containerhost
      - ntp
  ess-a4:
    #no_maas: True
    ip4: 11
    partitions: partbig
    network:
      manage:
        mac: 14:18:77:57:16:1D
    roles:
      - containerhost
      - ntp
  storage-a1:
    ip4: 12
    partitions: partsmall
    network:
      manage:
        mac: 18:66:DA:60:B1:C9
    roles:
      - containerhost
      - ostack