#!/usr/bin/env bash

# set -x

SCRIPTDIR=$(dirname $0)
. $SCRIPTDIR/lib/webserver

# configure hosts
cat <<EOF > /etc/hosts
127.0.0.1       localhost
10.1.48.10      ess-a1 ess-a1.cde.1nc

10.1.48.10  repo repo.cde.1nc
10.1.48.102 salt salt.cde.1nc

EOF

# remove resolv.conf
echo "" > /etc/resolv.conf

# configure interfaces
ifdown -a
cat <<EOF > /etc/network/interfaces
# added by cde configuration procedures
auto lo
iface lo inet loopback

auto eth2
iface eth2 inet static
    address 10.1.48.10/20

source-directory interfaces.d

EOF

if [ ! -d /srv/debian ]; then
  cat <<EOF > /etc/network/interfaces.d/eth0
# added by cde configuration procedures
auto eth0
iface eth2 inet static
    address 192.168.122.23/24

source-directory interfaces.d

EOF

fi
ifup -a
service ssh restart

# configure apt
cat <<EOF > /etc/apt/sources.list
deb http://repo.cde.1nc/cde/ubuntu trusty main restricted universe multiverse
deb http://repo.cde.1nc/cde/ubuntu trusty-updates main restricted universe multiverse
deb http://repo.cde.1nc/cde/ubuntu trusty-security main restricted universe multiverse

EOF

cat <<EOF > /etc/apt/sources.list.d/salt.list
deb http://repo.cde.1nc/cde/salt trusty main

EOF

echo 'APT:Install-Recommends "false";' > /etc/apt/apt.conf.d/02recommends

if ! apt-key list | grep -q "Cloud Services 1Net"; then
  apt-key add /srv/salt/base/repo/files/maas/alchemy.key
fi

# configure webserver
wsstart

apt-get clean
apt-get update
apt-get -qq upgrade -y

# install alchemy salt state tree
if [ ! -d /srv/debian ]; then
  apt-get install -y alchemy-saltstack
fi


wsstop
