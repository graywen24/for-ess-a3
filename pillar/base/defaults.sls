defaults:
  hint: This file is managed by salt - do not edit localy, changes will be overwritten.
  bashtimeout: 9000
  lxc:
    saltip: 10.3.50.102
    repoip: 10.3.50.101
    profile: ubuntu
  salt:
    url: http://repo.cde.1nc/salt/install_salt.sh
  hosts:
    network:
      manage:
         type: bridge
         name: eth0
         link: br-mgmt
         vpref: vma
         phys: eth2
      ostack:
         type: bond
         name: eth1
         link: br-stack
         vpref: vos
         phys: bond0
         bond:
           - eth0
           - eth1
      storage:
         type: bond
         name: eth2
         link: br-store
         vpref: vst
         phys: bond1
         bond:
           - eth4
           - eth5
      ha:
         type: bridge
         name: eth4
         link: br-ha
         vpref: vha
         phys: eth3
    roles:
      - metal
  containers:
    common:
      bootstrap: 1
    network:
      common:
        type: veth
        flags: up
        macprefix: 00:ee:1e
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
