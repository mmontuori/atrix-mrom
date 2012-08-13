#!/bin/bash

source kernelenv

cd ~/android/kernel/atrix-wifi-module/open-src/src/dhd/linux

make clean

make dhd-cdc-sdmmc-oob-gpl
