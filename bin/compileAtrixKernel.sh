#!/bin/bash


source kernelenv

cd $LINUXSRCDIR

if [ "$1" == "clean" ]; then
	make clean
	exit
fi

make oldconfig
make
make modules

cp arch/arm/boot/zImage ~/git_repos/atrix-mrom/cm_system/device/motorola/olympus/kernel
cp arch/arm/mach-tegra/*.ko ~/git_repos/atrix-mrom/cm_system/device/motorola/olympus/modules
