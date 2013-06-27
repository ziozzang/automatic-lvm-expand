automatic-lvm-expand
====================

by Jioh L. Jung (ziozzang@gmail.com)

Automatically Expand LVM partition with additional disk.
This script is used for VM provisioning.

Configuration
=============

```
# Target Device
# - Raw disk device. you can specify one device or use wildcard
TARGET_DEVICE="/dev/sd?"
# LVM group
TARGET_VOL_GRP="VolGroup"
# LVM mountpoint target
TARGET_VOL_MP="/dev/VolGroup/lv_root"
```

You can edit environment on script.
