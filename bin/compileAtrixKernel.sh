#!/bin/bash


source kernelenv

cd ~/android/kernel/kernel-MB860.faux123

if [ "$1" == "clean" ]; then
	make clean
fi

make oldconfig
make zImage
make modules
