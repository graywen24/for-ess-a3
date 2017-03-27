defaults:
  env: cde.1nc
  maas:
    dbuser: maas
    dbpass: 5RggMZQ0TAg7
    user: root
    pass: ABC123
    email: cas-system@1-net.com.sg
    key: ahV7Gcnb8GNdTGSvfD:EyshSE47PvcNWHDAcx:GRTUrmLaSSzx8FjCAZVU32vZPtpfzThs
    sub: hwe-v
    powerip: 10.1.16
    powertype: ipmi
    zone: CDE
  dns-servers:
    - 10.3.50.103
    - 10.3.50.104
  ntp-servers:
    type: server
    interfaces:
      first:
        main: br-mgmt
        fallback: eth2
    external:
      stdtime.gov.hk: 118.143.17.82
      time.hko.hk: 223.255.185.2
      ntp.nict.jp: 133.243.238.243
      time.nist.gov: 24.56.178.140
    internal:
      ntp1.cde.1nc: 10.3.50.10
      ntp2.cde.1nc: 10.3.50.11
  hosts:
    network:
      ostack:
         domain: ostack.cde.1nc
         ip4net: 10.3.34.{0}/20
      manage:
         domain: cde.1nc
         ip4net: 10.3.50.{0}/20
         gateway: 10.3.50.1
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
