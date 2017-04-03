defaults:
  env: wcc.1nc
  envo: ostack.wcc.1nc
  maas:
    key: qMTcMs7A67FqmneSSt:XH4ucxAxBDALkf6x5x:sR7RQQYb5BMfKHcPqSEztc89rNPPahRE
    sub: hwe-v
    powerip: 10.3.18
    powertype: ipmi
    zone: WCC
  dns-servers:
    - 10.3.50.103
    - 10.3.50.104
  ntp-servers:
    type: peer
    interfaces:
      first:
        main: br-mgmt
        fallback: eth2
    internal:
      ntp1.cde.1nc: 10.3.50.10
      ntp2.cde.1nc: 10.3.50.11
  hosts:
    network:
      ostack:
         domain: ostack.wcc.1nc
         ip4net: 10.3.34.{0}/24
      manage:
         domain: wcc.1nc
         ip4net: 10.3.48.{0}/20
         postup: route add -net 10.3.48.0/20 gw 10.3.48.1
         gateway: 10.3.48.1
      storage:
         domain: store.wcc.1nc
         ip4net: 10.3.65.{0}/20
         type: bridge
         name: eth2
         link: br-store
         vpref: vst
         phys: eth3
      ha:
        domain: ha.wcc.1nc
        ip4net: 192.168.100.{0}/24
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
        remote: var/storage
    lxcconf:
      lxc.start.auto: 1
      lxc.cgroup.devices.allow:
        allowmem: "c 1:1 rwm # allow reading /dev/mem :)"
    roles:
      - container
