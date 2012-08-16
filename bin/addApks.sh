#!/bin/bash

APK_DIR=~/android/apk
TMP_DIR=/tmp/cm_extract

if [ "$1" == "" ]; then
	echo "usage: addGapps.sh {ROM zip file}"
	exit 1
fi

if test -d $TMP_DIR; then
	rm -fr $TMP_DIR
fi

mkdir $TMP_DIR

cur_dir=`pwd`

CM_DIR=`dirname ${1}`
cd $CM_DIR
CM_FILE=`pwd`/`basename ${1}`

cd $cur_dir

echo CM_FILE: $CM_FILE

if ! test -d $APK_DIR; then
	echo "APK directory hnot found. Exiting!"
	exit 1
fi

cd $APK_DIR

zip -r $CM_FILE system
#zip -r $CM_FILE data
zip -d $CM_FILE /system/app/ADWLauncher.apk
#zip -d $CM_FILE /system/app/CMStats.apk

cd $TMP_DIR
unzip $CM_FILE system/build.prop

sed -i 's/dalvik.vm.heapsize=64m/dalvik.vm.heapsize=96m/' system/build.prop
sed -i 's/wifi.supplicant_scan_interval=30/wifi.supplicant_scan_interval=180/' system/build.prop
sed -i 's/persist.tegra.nvlog.level=4/# persist.tegra.nvlog.level=4/' system/build.prop
sed -i 's/ro.telephony.call_ring.delay=500/ro.telephony.call_ring.delay=0/' system/build.prop
echo "# mmontuori Atrix-MROM changes" >> system/build.prop
echo "windowsmgr.max_events_per_sec=150" >> system/build.prop
echo "debug.sf.hw=1" >> system/build.prop
echo "video.accelerate.hw=1" >> system/build.prop
echo "debug.performance.tuning=1" >> system/build.prop
echo "ro.config.nocheckin=1" >> system/build.prop
echo "ro.media.dec.jpeg.memcap=8000000" >> system/build.prop 
echo "ro.media.enc.hprof.vid.bps=8000000" >> system/build.prop
echo "ro.media.enc.jpeg.quality=100" >> system/build.prop
echo "ro.ril.disable.power.collapse=1" >> system/build.prop
echo "pm.sleep_mode=1" >> system/build.prop >> system/build.prop
echo "ro.kernel.android.checkjni=0" >> system/build.prop
echo "media.stagefright.enable-meta=true" >> system/build.prop
echo "media.stagefright.enable-scan=true" >> system/build.prop
echo "media.stagefright.enable-http=true" >> system/build.prop
echo "media.stagefright.enable-record=false" >> system/build.prop

zip -r $CM_FILE system/build.prop

#unzip $CM_FILE META-INF/com/google/android/updater-script
#$cur_dir/updater-script.sh >> META-INF/com/google/android/updater-script
#zip -r $CM_FILE META-INF/com/google/android/updater-script

