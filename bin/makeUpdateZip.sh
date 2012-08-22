#!/bin/bash

first=$1
second=$2
tmpdir=$3

if [ "$first" == "" ] ||
   [ "$second" == "" ]; then
	echo "usage: `basename $0` {release1} {release2} [tmp dir=/tmp/update-zip/]"
	exit
fi

if [ "$tmpdir" == "" ]; then
	tmpdir=/tmp/update-zip
fi

echo "release 1: $first"
echo "release 2: $second"
echo "tmpdir: $tmpdir"

if test -d $tmpdir; then
	echo "$tmpdir directory already exists, exiting..."
	exit 1
fi

curdir=`pwd`

echo "prepare $curdir/update.zip..."

if test -f $curdir/update.zip; then
	rm $curdir/update.zip
fi

if ! mkdir -p $tmpdir; then
	echo "error creating directory $tmpdir"
	exit 1
fi

cd $tmpdir

mkdir $first
mkdir $second
echo "extracting $first..."
cd $tmpdir/$first
unzip $curdir/$first >/dev/null
echo "extracting $second..."
cd $tmpdir/$second
unzip $curdir/$second >/dev/null

cd $tmpdir
echo "calculating differences..."
diffs=`diff -r --brief $first $second | grep -v "META-INF" | awk '{ print $4 }' | sed "s/$second\///"`

cd $second
tar cvf ../update.tar $diffs
tar uvf ../update.tar META-INF
gzip ../update.tar

cd $tmpdir
mkdir update-new
cd update-new
tar xvf ../update.tar.gz

echo 'assert(getprop("ro.product.device") == "olympus" || getprop("ro.build.product") == "olympus" || getprop("ro.product.board") == "olympus");' > META-INF/com/google/android/updater-script
echo 'show_progress(0.500000, 0);' >> META-INF/com/google/android/updater-script
echo 'mount("ext4", "EMMC", "/dev/block/mmcblk0p12", "/system");' >> META-INF/com/google/android/updater-script
echo 'package_extract_dir("system", "/system");' >> META-INF/com/google/android/updater-script
echo 'show_progress(0.200000, 0);' >> META-INF/com/google/android/updater-script
echo 'show_progress(0.200000, 10);' >> META-INF/com/google/android/updater-script
echo 'show_progress(0.200000, 10);' >> META-INF/com/google/android/updater-script
echo 'show_progress(0.100000, 0);' >> META-INF/com/google/android/updater-script
if test -f boot.img; then
	echo 'package_extract_file("boot.img", "/dev/block/mmcblk0p11");' >> META-INF/com/google/android/updater-script
fi
echo 'unmount("/system");' >> META-INF/com/google/android/updater-script

zip -r $curdir/update.zip *
