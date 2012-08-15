#!/bin/sh

cur_dir=`pwd`
echo 'mount("ext3", "EMMC", "/dev/block/mmcblk0p16", "/data");'
cd ~/android/apk
for file in `find data/app/*`; do
	echo "package_extract_file(\"$file\", \"/$file\");"
	echo "set_perm(0, 0, 0777, \"/$file\");"
done

for file in `find data/data/*/lib/*`; do
	echo "package_extract_file(\"$file\", \"/$file\");"
	echo "set_perm(0, 0, 0777, \"/$file\");"
done

echo 'unmount("/data");'
