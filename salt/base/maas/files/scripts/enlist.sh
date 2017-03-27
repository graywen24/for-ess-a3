#!/usr/bin/env bash

APIKEY=$1
node_id=""

create_node() {
  name=$1
  mac=$2
  arch=$3
  sub=$4

  node_exists=$(maas cde nodes list mac_address=$mac | awk -F"\"" '/system_id/ { print $4 }')

  if [ "$node_exists" != "" ]; then
    echo "Deleting node: $node_exists"
    maas cde node delete $node_exists > /dev/null
  fi

  node_id=$(maas cde nodes new architecture=$arch mac_addresses=$mac hostname=$name nodegroup=CDE subarchitecture=$sub | awk -F"\"" '/system_id/ { print $4 }')
  maas cde node abort-operation $node_id > /dev/null
  echo "created: $node_id"

}

power_node() {
  powertype=$1
  powerip=$2

  ppass=$(pwgen -nc 15 1)
  pparams=""
  icmd="ipmitool -I lanplus -H $powerip -U root -P 2m@nyw0rk"

  case $powertype in
   'ipmi')
      has_user=$($icmd user list | grep maas | awk '{ print $1}')
      if [ "$has_user" != "" ]; then
        $icmd user set password $has_user $ppass
      else
       maxnum=$($icmd user list | tail -1 | awk '{ print $1}')
       $icmd user set name $((maxnum + 1)) maas
       $icmd user set password $((maxnum + 1)) $ppass
       $icmd channel setaccess $((maxnum + 1)) link=on ipmi=on callin=on privilege=4
       ipmitool user enable $((maxnum + 1))
      fi

      maas cde node update $node_id \
      power_type=$powertype \
      power_parameters_power_driver=LAN_2_0 \
      power_parameters_power_address=$powerip \
      power_parameters_power_user=maas \
      power_parameters_power_pass=$ppass > /dev/null

   ;;
   'amt')
      ppass=$3
      maas cde node update $node_id \
      power_type=$powertype \
      power_parameters_power_address=$powerip \
      power_parameters_power_pass=$ppass > /dev/null
   ;;
  esac
}

tag_node() {
  tag=$1
  maas cde tags list | grep -q $tag || maas cde tags new name=$tag > /dev/null
  maas cde tag update-nodes $tag add=$node_id > /dev/null
}

zone_node() {
  zone=$1
  maas cde zones read | grep -q $zone || maas cde zones create name=$zone > /dev/null
  maas cde node update $node_id zone=$zone> /dev/null
}

commission_node() {
  maas cde node commission $node_id > /dev/null
}

maas login cde http://localhost/MAAS/api/1.0 $APIKEY  > /dev/null
source ./enlisthosts.{{ pillar.defaults.env }}.sh

maas logout cde
