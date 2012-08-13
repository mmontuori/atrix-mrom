#!/bin/bash

if [ "$1" == "" ]; then
	echo "makebootimg.sh {kernel dir}"
	exit 1
fi

export KERN_DIR=$1

if ! test -f $KERN_DIR/arch/arm/boot/zImage; then
	echo "ERROR: file $KERN_DIR/arch/arm/boot/zImage not found!"
	exit 1
fi

modules=`find $KERN_DIR | grep "ko$"`

cur_dir=`pwd`

if cd update-zip/system/lib; then
#	rm *
	for module in $modules; do
		cp $module .
	done
fi

cd $cur_dir
cp dhd.ko update-zip/system/lib

#split_bootimg.pl /home/michael/android/system/out/target/product/olympus/boot.img

/home/michael/android/system/out/host/linux-x86/bin/mkbootimg --kernel $KERN_DIR/arch/arm/boot/zImage --ramdisk boot.img.orig-ramdisk.gz -o boot.img
#/home/michael/android/system/out/host/linux-x86/bin/mkbootimg --cmdline 'mem=320M@0M nvmem=192M@320M mem=512M@512M vmalloc=320M video=tegrafb console=null usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=mbr:d00:100:800,kpanic:2100:400:800 security=tomoyo mot_prod=1 androidboot.serialno=TA2070KNGD' --kernel $KERN_DIR/arch/arm/boot/zImage --ramdisk boot.img-ramdisk.gz -o boot.img
#/home/michael/android/system/out/host/linux-x86/bin/mkbootimg --kernel boot.img.orig-kernel --ramdisk boot.img.orig-ramdisk.gz -o boot.img

cp boot.img update-zip/kernel

rm update.zip
cd update-zip
zip -r ../update.zip *
