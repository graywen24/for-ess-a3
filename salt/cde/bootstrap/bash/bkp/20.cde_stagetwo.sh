#!/usr/bin/env bash

SCRIPTDIR=$(dirname $0)
. $SCRIPTDIR/lib/webserver
. $SCRIPTDIR/lib/steps

description="Steps to ensure the basic services salt, repo and DNS are up and running"
steps[0]="master:Configure the master, accept keys, ensure minions are reachable"
steps[1]="basic:Install the repository and dns server"
steps[2]="shining:Make the new world shine - apply states to the new machines"

minit $STEP

wsstart

if action master; then

  if ! grep -q maas-a1 /var/lib/lxc/saltmaster-a1/rootfs/etc/hosts; then
    cat <<EOF >> /var/lib/lxc/saltmaster-a1/rootfs/etc/hosts
10.1.48.10 ess-a1.cde.1nc
10.1.48.101 repo-a1.cde.1nc
10.1.48.102 saltmaster-a1.cde.1nc
10.1.48.103 micros-a1.cde.1nc

EOF
  fi

  lxc-attach -n saltmaster-a1 -- salt-key -A -y
  sleep 5

  lxc-attach -n saltmaster-a1 -- salt \* test.ping

fi

if action basic; then
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls system.upgrade
  lxc-attach -n saltmaster-a1 -- salt repo-a1.cde.1nc state.sls repo
  lxc-attach -n saltmaster-a1 -- salt micros-a1.cde.1nc state.sls bind
fi

if action shining; then
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls core.roles
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls core.resolver
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls core
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls debug.unlocked
  lxc-attach -n saltmaster-a1 -- salt \*.cde.1nc state.sls sshd

  # reinstall and enforce our services
  lxc-attach -n saltmaster-a1 -- salt repo-a1.cde.1nc state.sls repo
  lxc-attach -n saltmaster-a1 -- salt micros-a1.cde.1nc state.sls bind
  lxc-attach -n saltmaster-a1 -- salt micros-a1.cde.1nc state.sls dhcpd

fi


wsstop

