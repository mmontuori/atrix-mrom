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
zip -r $CM_FILE data
zip -d $CM_FILE /system/app/ADWLauncher.apk

cd $TMP_DIR
unzip $CM_FILE META-INF/com/google/android/updater-script
$cur_dir/updater-script.sh >> META-INF/com/google/android/updater-script
zip -r $CM_FILE META-INF/com/google/android/updater-script

