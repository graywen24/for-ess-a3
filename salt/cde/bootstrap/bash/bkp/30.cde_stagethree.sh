#!/usr/bin/env bash

SCRIPTDIR=$(dirname $0)
. $SCRIPTDIR/lib/steps

description="Steps to expand the salt dominion - get maas up and running, deploy"
steps[0]="maas:Setup maas service"

minit $STEP

if action maas; then

  lxc-attach -n saltmaster-a1 -- salt ess-a1.cde.1nc container.deployed maas-a1 test=false
  sleep 5
  lxc-attach -n saltmaster-a1 -- salt-key -A -y
  sleep 10
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls system.upgrade
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls core.roles
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls core
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls debug.unlocked
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls sshd
  lxc-attach -n saltmaster-a1 -- salt maas-a1.cde.1nc state.sls maas

fi


#if [ "HOSTNAME" != "saltmaster-a1" ]; then
#  echo "You need to run this on the saltmaster!"
#  exit 1
#fi


