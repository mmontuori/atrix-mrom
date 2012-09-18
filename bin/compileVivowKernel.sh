#!/bin/bash


source kernelenv-vivow

cd $LINUXSRCDIR

if [ "$1" == "clean" ]; then
	make clean
	exit
fi

make oldconfig
make
make modules

cp arch/arm/boot/zImage ~/git_repos/atrix-mrom/cm_system/device/htc/vivow/prebuilt/kernel
#cp arch/arm/mach-tegra/*.ko ~/git_repos/atrix-mrom/cm_system/device/motorola/olympus/modules
#cp drivers/scsi/scsi_wait_scan.ko ~/git_repos/atrix-mrom/cm_system/device/motorola/olympus/modules
#cp drivers/misc/vpndriver/vpnclient.ko ~/git_repos/atrix-mrom/cm_system/device/motorola/olympus/modules
