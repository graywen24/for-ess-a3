#!/usr/bin/env bash

# set -x

SCRIPTDIR=$(dirname $0)
. $SCRIPTDIR/lib/webserver
. $SCRIPTDIR/lib/steps

description="Steps to create a masterless minion and deploy the containers for basic services"
steps[0]="minion:Setup the masterless minion on this machine"
steps[1]="local:Run the states for the local minion to init this machine"
steps[2]="machine:Setting up grub and networking - needs reboot"
steps[3]="miniverse:Setup minimal salt universe with container saltmaster-a1, repo-a1 and micros-a1"

minit $STEP

wsstart

if action minion; then
  # configure salt
  echo "Running step minion ..."
  apt-get install -y salt-minion
  service salt-minion stop
  rm -f /etc/salt/minion.d/masterless.conf
  rm -rf /etc/salt/pki
  rm -rf /var/cache/salt/minion/*
  echo "" > /etc/resolv.conf

# configure hosts
#cat <<EOF > /etc/hosts
#127.0.0.1       localhost
#10.1.48.10      ess-a1 ess-a1.cde.1nc

#10.1.48.10  repo repo.cde.1nc
#10.1.48.102 salt salt.cde.1nc

#EOF

  cat <<EOF > /etc/salt/minion.d/masterless.conf
file_client: local

file_roots:
  base:
    - /srv/salt/base
  cde:
    - /srv/salt/cde

pillar_roots:
  base:
    - /srv/pillar/base
  cde:
    - /srv/pillar/cde

EOF
fi

if action local; then
  # remember, we are on a fresh ess-a1 ...
  salt-call -l error state.sls core.roles
  salt-call -l error state.sls core.packages
  salt-call -l error state.sls core.timezone
  salt-call -l error state.sls core.sync
  salt-call -l error state.sls containerhost
fi


if action machine; then
  # remember, we are on a fresh ess-a1 ...
  salt-call -l error state.sls core.grub
  salt-call -l error state.sls network.containerhost
  cat <<EOF
***************************************************************************************
*                                                                                     *
* Important changes have been done to the system - you need to reboot before proceed! *
*                                                                                     *
***************************************************************************************
EOF
fi

if action miniverse; then
  salt-call -l info container.deployed saltmaster-a1 test=false profile=cde-bootstrap

  lxc-attach -n saltmaster-a1 -- service salt-minion stop
  lxc-attach -n saltmaster-a1 -- rm -rf /etc/salt/pki
  lxc-attach -n saltmaster-a1 -- dpkg -i /var/storage/alchemy-saltstack_1.0-10_amd64.deb
  lxc-attach -n saltmaster-a1 -- apt-get install -y salt-master
  lxc-attach -n saltmaster-a1 -- service salt-minion start
  sleep 5

  salt-call -l info container.deployed repo-a1 test=false profile=cde-bootstrap
  salt-call -l info container.deployed micros-a1 test=false profile=cde-bootstrap

  service salt-minion stop
  rm -f /etc/salt/minion.d/masterless.conf
  rm -rf /etc/salt/pki
  rm -rf /var/cache/salt/minion/*
  lxc-attach -n saltmaster-a1 -- salt-key -y -d ess-a1*
  service salt-minion start

  sleep 5
  lxc-attach -n saltmaster-a1 -- salt-key -L
fi

wsstop
