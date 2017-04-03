mine_functions:
  network.interfaces:
    interface: eth0
  network.ip_addrs:
    cidr: '10.3.48.0/20'
  workspace:
    - mine_function: grains.get
    - workspace