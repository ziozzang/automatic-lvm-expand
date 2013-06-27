#!/bin/bash
###############################################################
# Code by Jioh L. Jung (ziozzang@gmail.com)
###############################################################
# Configuration
# Target Device
# - Raw disk device. you can specify one device or use wildcard
TARGET_DEVICE="/dev/sd?"
# LVM group
TARGET_VOL_GRP="VolGroup"
# LVM mountpoint target
TARGET_VOL_MP="/dev/VolGroup/lv_root"
 
###############################################################
# Flag for size change
SIZE_CHANGED="false"
 
for disk in ${TARGET_DEVICE}
do
  # Check Already Partioned
  if [[ -e ${disk}1 ]]; then
    echo "==> ${disk}1 partition already exist"
    continue
  else
    echo "==> ${disk} is not partioned"
    echo "==> Create MBR label"
    parted -s $disk  mklabel msdos
    ncyl=$(parted $disk unit cyl print  | sed -n 's/.*: \([0-9]*\)cyl/\1/p')
    if [[ $ncyl != [0-9]* ]]; then
      echo "disk $disk has invalid cylinders number: $ncyl"
      continue
    fi
    echo "==> create primary parition 1 with $ncyl cylinders"
    parted -a optimal $disk mkpart primary 0cyl ${ncyl}cyl
    echo "==> set partition $partno to type: lvm "
    parted $disk set 1 lvm on
    partprobe > /dev/null 2>&1
    echo "==> created PV ${disk}1 as LVM Partition"
    echo "==> Extend Volume ${TARGET_VOL_GRP}"
    vgextend ${TARGET_VOL_GRP} ${disk}1
    echo "==> Extend Volume Partition to ${TARGET_VOL_MP}"
    lvextend ${TARGET_VOL_MP} ${disk}1
    SIZE_CHANGED="true"
  fi
done
if [[ "${SIZE_CHANGED}" == "true" ]]; then
  echo "==> LVM root will be resize on the fly.."
  resize2fs ${TARGET_VOL_MP}
fi
echo "==> Done"
