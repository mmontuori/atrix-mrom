#!/bin/bash

APK_DIR=~/android/apk

if [ "$1" == "" ]; then
	echo "usage: addGapps.sh {ROM zip file}"
	exit 1
fi

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
