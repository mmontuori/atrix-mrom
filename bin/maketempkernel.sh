#!/bin/bash

tmp_dir=/tmp/kernel
modules_dir=system/lib/modules
atrix_wifi_dir=~/git_repos/atrix-wifi-module
server=c02.leetnet.com
mkbootimg_exec=~/android/mrom-ics/out/host/linux-x86/bin/mkbootimg
kernel_zip=/tmp/debug_cm7_kernel.zip

if [ "$1" == "" ] || [ "$2" == "" ]; then
	echo "usage: maketempkernel.sh {source zip file} {zImage}"
	exit
fi

if test -d $tmp_dir; then
	if ! rm -fr $tmp_dir; then
		echo "error clearing $tmp_dir"
		exit
	fi
fi

mkdir $tmp_dir
cd $tmp_dir

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
	echo "copying $module to $modules_dir..."
	if ! cp $module $modules_dir; then
		echo "error copying file $module to $modules_dir"
		exit
	fi
done

#cp ~/android/mrom-ics/out/target/product/olympus/boot.img boot.img

split_bootimg.pl boot.img 

$mkbootimg_exec --kernel $2 --ramdisk boot.img-ramdisk.gz -o boot.img

rm boot.img-*

rm system/lib/modules/*

wifi_module=`find $atrix_wifi_dir | grep "dhd.ko.stripped$"`

echo "copying $wifi_module to $modules_dir..."
if ! cp $wifi_module ${modules_dir}/dhd.ko; then
        echo "error copying file $wifi_module to $modules_dir"
        exit
fi


pwd

modules_dir=`dirname $2`
echo $modules_dir
for module in `find $modules_dir/../../../ | grep "\.ko$"`; do
        cp $module system/lib/modules
done

cp ~/android/kernel/lime-forensics/src/lime-goldfish.ko system/lib/modules/lime.ko

rm $kernel_zip

zip -r $kernel_zip *

#echo "Uploading module to $server..."
#scp $kernel_zip ${server}:~
#kernel_zip_file=`basename $kernel_zip`
#ssh $server "mv ~/$kernel_zip_file montuori/files"
