
source setenv

init_repo

check_proprietary_files

check_rom_manager

export CM_BUILDTYPE=EXPERIMENTAL

if [ "$1" == "sync" ]; then
	sync_repo
	exit
fi

cd $REPO_HOME/cm_system

files=`find .`

for file in $files; do
	#echo $file
	#echo $CM_DIR/$file
	if ! diff $file $CM_DIR/$cm_file>/dev/null; then
		echo Applying changes to $CM_DIR/$cm_file from $file...
		#if ! test -f "${cm_file}.cm_orig"; then
			#echo copying $cm_file to ${cm_file}.cm_orig...
			#cp $cm_file ${cm_file}.cm_orig
		#fi
		#cp $mmontuori_file $cm_file
	fi
done

exit

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

brunch olympus

