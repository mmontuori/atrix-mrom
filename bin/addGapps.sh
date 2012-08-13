#!/bin/bash

if [ "$1" == "" ]; then
	echo "usage: addGapps.sh {ROM zip file} {google zip file}"
	exit 1
fi

if test -d tmp/gapps; then
	echo "removing tmp/gapps..."
	rm -fr tmp/gapps
fi

mkdir tmp/gapps
cd tmp/gapps
unzip $2

zip -r $1 system
