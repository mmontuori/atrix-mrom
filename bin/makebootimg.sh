#!/bin/bash

if [ "$1" == "" ]; then
	echo "makebootimg.sh {boot.img file} {zimage file}"
	exit 1
fi

bootimg=$1
zimage=$2

for file in `echo $bootimg $zimage`; do
	if ! test -f $file; then
		echo "$file not found!"
		exit
	fi
done

cd /tmp

split_bootimg.pl $bootimg

~/android/mrom-ics/out/host/linux-x86/bin/mkbootimg --kernel $zimage --ramdisk /tmp/boot.img-ramdisk.gz -o /tmp/boot.img

rm /tmp/boot.img-*

echo "file /tmp/boot.img has been created"
