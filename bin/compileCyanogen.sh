
source setenv

init_repo

check_proprietary_files

check_rom_manager

export CM_BUILDTYPE=EXPERIMENTAL

if [ "$1" == "sync" ]; then
	sync_repo
	exit
fi

if [ "$1" == "getfiles" ] && [ "$2" == "" ]; then
	echo "usage: compileCyanogen.sh getfiles {device}"
	exit
fi

if [ "$1" == "getfiles" ] && [ "$2" == "" ]; then
	cd $CM_DIR
	cd device/htc/$2/
	./extract-files.sh 
	exit
fi


if [ "$1" == "" ]; then
	echo "./compileCyanogen.sh {device}"
	exit
fi

device=$1

if test -L ${CM_DIR}/out; then
	rm ${CM_DIR}/out
fi

if ! test -d ${CM_DIR}/out.${device} && [ "$1" != "diff" ]; then
	mkdir ${CM_DIR}/out.${device}
fi

if [ "$1" != "diff" ]; then
	ln -s ${CM_DIR}/out.${device} ${CM_DIR}/out
fi

cd $REPO_HOME

if [ "$1" != "diff" ]; then
	cp doc/Atrix-MROM-Changelog.txt ${CM_DIR}/vendor/cyanogen/CHANGELOG.mkdn
fi

cd $REPO_HOME/cm_system

files=`find * -type f`

for file in $files; do
	#echo file:$file
	#echo cm_file:$CM_DIR/$file
	if ! diff $file $CM_DIR/$file>/dev/null; then
		if [ "$1" != "diff" ]; then
			echo Applying changes to $CM_DIR/$file from $file...
			tmp_dir=`dirname $CM_DIR/$file`
			if ! test -d $tmp_dir; then
				mkdir -p $tmp_dir
			fi
			cp $file $CM_DIR/$file
		else
			echo files $CM_DIR/$file and $file are different...
		fi
	fi
done

if [ "$1" == "diff" ]; then
	exit
fi

if ! cat $CM_DIR/vendor/cyanogen/products/common.mk | grep "90mrom"; then
	echo "Updating $CM_DIR/vendor/cyanogen/products/common.mk..."
	echo "" >> $CM_DIR/vendor/cyanogen/products/common.mk
	echo "# mmontuori mrom speed" >> $CM_DIR/vendor/cyanogen/products/common.mk
	echo "PRODUCT_COPY_FILES += \\" >> $CM_DIR/vendor/cyanogen/products/common.mk
    	echo "vendor/cyanogen/prebuilt/common/etc/init.d/90mrom:system/etc/init.d/90mrom" >> $CM_DIR/vendor/cyanogen/products/common.mk
	echo "# end of mmontuori change" >> $CM_DIR/vendor/cyanogen/products/common.mk
fi

if ! cat $CM_DIR/device/bn/encore/encore.mk | grep "sysctl.conf"; then
	echo "Updating $CM_DIR/device/bn/encore/encore.mk..."
	echo "" >> $CM_DIR/device/bn/encore/encore.mk
	echo "# mmontuori mrom speed" >> $CM_DIR/device/bn/encore/encore.mk
	echo "PRODUCT_COPY_FILES += \\" >> $CM_DIR/device/bn/encore/encore.mk
    	echo "device/bn/encore/config/sysctl.conf:system/etc/sysctl.conf" >> $CM_DIR/device/bn/encore/encore.mk
	echo "# end of mmontuori change" >> $CM_DIR/device/bn/encore/encore.mk
fi

#cd packages/apps/Settings/res

#for file in `find . 2>/dev/null`; do
#	echo $file
#	if ! test -d $file && cat $file | grep CyanogenMod>/dev/null; then
#		cp $file $file.cm_orig
#		cp $file $file.mmontuori
#		sed -i s/CyanogenMod/Atrix-MROM/g $file.mmontuori
#	fi
#done

cd $CM_DIR

. build/envsetup.sh

brunch $device

