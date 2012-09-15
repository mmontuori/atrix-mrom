#!/bin/bash

. setenv

cd $REPO_HOME/cm_system

files=`find . -type f`

for file in $files; do
	echo "checking $file -> $CM_DIR/$file"...
	diff $file $CM_DIR/$file
done
