
source setenv

init_repo

check_proprietary_files

check_rom_manager

export CM_BUILDTYPE=EXPERIMENTAL

if [ "$1" == "sync" ]; then
	sync_repo
fi

cd $SYS_DIR

mmontuori_files=`find . | grep mmontuori`

for mmontuori_file in $mmontuori_files; do
	cm_file=`echo $mmontuori_file | sed 's/.mmontuori//g'`
	if ! diff $mmontuori_file $cm_file>/dev/null; then
		echo Applying changes to $cm_file from $mmontuori_file...
		if ! test -f "${cm_file}.cm_orig"; then
			echo copying $cm_file to ${cm_file}.cm_orig...
			cp $cm_file ${cm_file}.cm_orig
		fi
		cp $mmontuori_file $cm_file
	fi
done

#cd packages/apps/Settings/res

#for file in `find . 2>/dev/null`; do
#	echo $file
#	if ! test -d $file && cat $file | grep CyanogenMod>/dev/null; then
#		cp $file $file.cm_orig
#		cp $file $file.mmontuori
#		sed -i s/CyanogenMod/Atrix-MROM/g $file.mmontuori
#	fi
#done

. build/envsetup.sh

brunch olympus

