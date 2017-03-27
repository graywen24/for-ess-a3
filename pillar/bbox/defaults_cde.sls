defaults:
  env: cde.1nc
  maas:
    key: ahV7Gcnb8GNdTGSvfD:EyshSE47PvcNWHDAcx:GRTUrmLaSSzx8FjCAZVU32vZPtpfzThs
    sub: hwe-v
    powerip: 10.1.16
    powertype: ipmi
    zone: CDE
  dns-servers:
    - 10.1.48.103
    - 10.1.48.104
  ntp-servers:
    type: server
    interfaces:
      first:
        main: br-mgmt
        fallback: eth2
    external:
      stdtime.gov.hk: 192.168.122.1
    internal:
      ntp1.cde.1nc: 10.1.48.10
      ntp2.cde.1nc: 10.1.48.11
  hosts:
    network:
      manage:
         domain: cde.1nc
         ip4net: 10.1.48.{0}/20
         gateway: 10.1.48.1
      ostack:
         domain: os.cde.1nc
         ip4net: 10.1.32.{0}/20
         gateway: 10.1.32.1
    roles:
      - metal
  containers:
    common:
      bootstrap: 1
    network:
      common:
        type: veth
        flags: up
        macprefix: 00:ee:1f
    mount:
      storage:
        local: /var/storage/{0}
        remote: /var/storage
    lxcconf:
      lxc.start.auto: 1
      lxc.cgroup.devices.allow:
        allowmem: "c 1:1 rwm # allow reading /dev/mem :)"
    roles:
      - container

