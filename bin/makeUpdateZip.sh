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

echo "diffs: $diffs"

cd $second
tar cvf ../update.tar $diffs Only system/app/Atrix-MROM.apk system/etc/init.d/07sdcard

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
echo 'set_perm_recursive(0, 0, 0755, 0644, "/system");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 2000, 0755, 0755, "/system/bin");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 3003, 02750, "/system/bin/netcfg");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 3004, 02755, "/system/bin/ping");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 1001, 04770, "/system/bin/pppd-ril");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 2000, 06750, "/system/bin/run-as");' >> META-INF/com/google/android/updater-script
echo 'set_perm(1000, 1003, 02755, "/system/bin/screenshot");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(1002, 1002, 0755, 0440, "/system/etc/bluetooth");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 0755, "/system/etc/bluetooth");' >> META-INF/com/google/android/updater-script
echo 'set_perm(1000, 1000, 0640, "/system/etc/bluetooth/auto_pairing.conf");' >> META-INF/com/google/android/updater-script
echo 'set_perm(3002, 3002, 0444, "/system/etc/bluetooth/blacklist.conf");' >> META-INF/com/google/android/updater-script
echo 'set_perm(1002, 1002, 0440, "/system/etc/dbus.conf");' >> META-INF/com/google/android/updater-script
echo 'set_perm(1014, 2000, 0550, "/system/etc/dhcpcd/dhcpcd-run-hooks");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 2000, 0755, 0750, "/system/etc/init.d");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 0755, "/system/etc/init.d");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 2000, 0550, "/system/etc/init.goldfish.sh");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 0544, "/system/etc/install-recovery.sh");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 0, 0755, 0555, "/system/etc/ppp");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 2000, 0755, 0644, "/system/vendor");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 0, 0755, 0644, "/system/vendor/firmware");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 2000, 0755, "/system/vendor/firmware");' >> META-INF/com/google/android/updater-script
echo 'set_perm_recursive(0, 2000, 0755, 0755, "/system/xbin");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/hcitool");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/librank");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/procmem");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/procrank");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/su");' >> META-INF/com/google/android/updater-script
echo 'set_perm(0, 0, 06755, "/system/xbin/tcpdump");' >> META-INF/com/google/android/updater-script
if test -f boot.img; then
	echo 'package_extract_file("boot.img", "/dev/block/mmcblk0p11");' >> META-INF/com/google/android/updater-script
fi
echo 'unmount("/system");' >> META-INF/com/google/android/updater-script

zip -r $curdir/update.zip *
