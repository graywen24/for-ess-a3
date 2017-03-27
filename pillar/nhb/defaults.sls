defaults:
  env: nhb.1nc
  envo: ostack.nhb.1nc
  maas:
    key: ahV7Gcnb8GNdTGSvfD:EyshSE47PvcNWHDAcx:GRTUrmLaSSzx8FjCAZVU32vZPtpfzThs
    sub: hwe-v
    powerip: 10.2.16
    powertype: ipmi
    zone: NHB
  dns-servers:
    - 10.1.48.103
    - 10.1.48.104
  ntp-servers:
    type: peer
    interfaces:
      first:
        main: br-mgmt
        fallback: eth2
    internal:
      ntp1.cde.1nc: 10.1.48.10
      ntp2.cde.1nc: 10.1.48.11
  hosts:
    network:
      ostack:
         domain: ostack.nhb.1nc
         ip4net: 10.2.32.{0}/20
      manage:
         domain: nhb.1nc
         ip4net: 10.2.48.{0}/20
         postup: route add -net 10.1.48.0/20 gw 10.2.48.1
         gateway: 10.2.48.1
      storage:
         domain: store.nhb.1nc
         ip4net: 10.2.64.{0}/20
      ha:
        domain: ha.nhb.1nc
        ip4net: 192.168.100.{0}/24
      nhb:
         domain: internal.nhb.1nc
         ip4net: 192.168.81.{0}/23
         type: bond
         name: eth2
         link: br-nhb
         vpref: vnh
         phys: bond1
         bond:
           - eth4
           - eth5
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
