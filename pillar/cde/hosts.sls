hosts:
  ess-a3:
    no_maas: True
    ip4: 10
    partitions: partbig
    network:
      manage:
        mac:18:66:DA:68:AD:5B
    roles:
      - containerhost
      - ntp
  ess-a4:
    ip4: 11
    partitions: partsmall
    network:
      manage:
        mac: 18:66:DA:60:AE:1D
    roles:
      - containerhost
      - ntp
