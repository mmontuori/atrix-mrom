#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]; then
	echo "usage: maketempkernel.sh {source zip file} {zImage}"
	exit
fi

if test -d /tmp/kernel; then
	if cd /tmp/kernel; then
		rm -fr *
	fi
	cd /tmp
	if ! rmdir kernel; then
		echo "error clearing /tmp/kernel"
		exit
	fi
fi

mkdir /tmp/kernel
cd /tmp/kernel

if ! test -f $1; then
	echo "source zip file $1 not found!"
	exit
fi

if ! test -f $2; then
	echo "error zImage file $2 not found"
	exit
fi

unzip $1

kernel_dir=`dirname $2`

modules=`find $kernel_dir/../../../ | grep "\.ko$"`

for module in $modules; do
	echo "copying $module to systen/lib/modules..."
	if ! cp $module system/lib/modules; then
		echo "error copying file $module to system/lib/modules"
		exit
	fi
done

wifi_module=`find ~/git_repos/atrix-wifi-module | grep "dhd.ko.stripped$"`

echo "copying $wifi_module to system/lib/modules..."
if ! cp $wifi_module system/lib/modules/dhd.ko; then
	echo "error copying file $wifi_module to system/lib/modules"
	exit
fi

split_bootimg.pl boot.img 

~/android/mrom-ics/out/host/linux-x86/bin/mkbootimg --kernel $2 --ramdisk boot.img-ramdisk.gz -o boot.img

rm boot.img-*

zip -r ../testkernel.zip *
