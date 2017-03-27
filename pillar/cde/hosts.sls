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
    ip4: 11
    partitions: partbig
    network:
      manage:
        mac: 44:A8:42:2E:7F:C2
    roles:
      - containerhost
      - ntp
