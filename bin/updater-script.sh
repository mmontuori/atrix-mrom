#!/bin/sh

echo 'mount("ext4", "EMMC", "/dev/block/mmcblk0p12", "/system");'
echo 'package_extract_dir("data", "/data");'
echo 'set_perm(0, 0, 0644, "/data/app");'
echo 'set_perm(0, 0, 0755, "/data/data/com.alensw.PicFolder/lib/libqpicjni88.so");'
echo 'unmount("/data");'
