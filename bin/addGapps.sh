#!/bin/bash

TMP_DIR=/tmp/gapps

if [ "$1" == "" ] && [ "$2" == "" ]; then
	echo "usage: addGapps.sh {ROM zip file} {google zip file}"
	exit 1
fi

cur_dir=`pwd`

CM_DIR=`dirname ${1}`
cd $CM_DIR
CM_FILE=`pwd`/`basename ${1}`

cd $cur_dir

GAPPS_DIR=`dirname ${2}`
cd $GAPPS_DIR
GAPPS_FILE=`pwd`/`basename ${2}`

echo CM_FILE: $CM_FILE
echo GAPPS_FILE: $GAPPS_FILE

cd $cur_dir

if test -d $TMP_DIR; then
	echo "removing ${TMP_DIR}..."
	rm -fr $TMP_DIR
fi

mkdir $TMP_DIR

unzip $GAPPS_FILE -d $TMP_DIR

cd $TMP_DIR

zip -r $CM_FILE system
