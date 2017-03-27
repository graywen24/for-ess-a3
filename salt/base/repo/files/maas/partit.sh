#!/usr/bin/env bash

# Partitioning helper for maas curtin install
# two params will be passed:
# $1 - the type of partitioning wanted
# $2 - the path to the fstab file
# $3 - target mount point

parttype=$1
fstabout=$2
target=$3

parttest() {

  # zapp the disk
  sgdisk -Z /dev/sda

  # grub partition because of gpt table
  sgdisk -n 1:0:+1M -t 1:ef02 -c 1:bios_grub /dev/sda

  # swap
  sgdisk -n 2:0:+64M -t 2:8200 -c 2:p_swap /dev/sda
  mkswap /dev/sda2
  echo "/dev/sda2   swap    swap    defaults    0 0" > $fstabout

  # system
  sgdisk -n 3:0:+10G -t 3:8300 -c 3:p_system /dev/sda
  mkfs.ext4 -q /dev/sda3
  echo "/dev/sda3   /       ext4    errors=remount-ro   0 1" >> $fstabout

  # var
  sgdisk -n 4:0:+10G -t 4:8300 -c 4:p_var /dev/sda
  mkfs.ext4 -q /dev/sda4
  echo "/dev/sda4   /var    ext4    defaults,noatime   0 0" >> $fstabout

  # lxc container
  sgdisk -n 5:0:+20G -t 5:8300 -c 5:p_lxc /dev/sda
  mkfs.ext4 -q /dev/sda5
  echo "/dev/sda5   /var/lib/lxc    ext4    defaults,noatime   0 0" >> $fstabout

  # storage
  sgdisk -n 6:0:0 -t 6:8300 -c 6:p_storage /dev/sda
  mkfs.ext4 -q /dev/sda6
  echo "/dev/sda6   /var/storage    ext4    defaults,noatime   0 0" >> $fstabout

  mount /dev/sda3 $target
  mkdir $target/var
  mount /dev/sda4 $target/var

  mkdir -p $target/var/lib/lxc
  mkdir -p $target/var/storage
}


partbig() {

  # zapp the disk
  sgdisk -Z /dev/sda

  # grub partition because of gpt table
  sgdisk -n 1:0:+1M -t 1:ef02 -c 1:bios_grub /dev/sda

  # swap
  sgdisk -n 2:0:+512G -t 2:8200 -c 2:p_swap /dev/sda
  mkswap /dev/sda2
  echo "/dev/sda2   swap    swap    defaults    0 0" > $fstabout

  # system
  sgdisk -n 3:0:+100G -t 3:8300 -c 3:p_system /dev/sda
  mkfs.ext4 -q /dev/sda3
  echo "/dev/sda3   /       ext4    errors=remount-ro   0 1" >> $fstabout

  # var
  sgdisk -n 4:0:+100G -t 4:8300 -c 4:p_var /dev/sda
  mkfs.ext4 -q /dev/sda4
  echo "/dev/sda4   /var    ext4    defaults,noatime   0 0" >> $fstabout

  # lxc container
  sgdisk -n 5:0:+500G -t 5:8300 -c 5:p_lxc /dev/sda
  mkfs.ext4 -q /dev/sda5
  echo "/dev/sda5   /var/lib/lxc    ext4    defaults,noatime   0 0" >> $fstabout

  # storage
  sgdisk -n 6:0:0 -t 6:8300 -c 6:p_storage /dev/sda
  mkfs.ext4 -q /dev/sda6
  echo "/dev/sda6   /var/storage    ext4    defaults,noatime   0 0" >> $fstabout

  mount /dev/sda3 $target
  mkdir $target/var
  mount /dev/sda4 $target/var

  mkdir -p $target/var/lib/lxc
  mkdir -p $target/var/storage
}


partsmall() {

  # zapp the disk
  sgdisk -Z /dev/sda

  # grub partition because of gpt table
  sgdisk -n 1:0:+1M -t 1:ef02 -c 1:bios_grub /dev/sda

  # swap
  sgdisk -n 2:0:+32G -t 2:8200 -c 2:p_swap /dev/sda
  mkswap /dev/sda2
  echo "/dev/sda2   swap    swap    defaults    0 0" > $fstabout

  # system
  sgdisk -n 3:0:0 -t 3:8300 -c 3:p_system /dev/sda
  mkfs.ext4 -q /dev/sda3
  echo "/dev/sda3   /       ext4    errors=remount-ro   0 1" >> $fstabout

  mount /dev/sda3 $target

}

case $1 in
 'partbig') partbig ;;
 'partsmall') partsmall ;;
 'parttest') parttest ;;
esac
