
source setenv

init_repo

cd $KERNEL_DIR

if ! test -d $KERNEL_DIR/${KERNEL_TYPE}; then
	#git clone git://github.com/CyanogenMod/${KERNEL_TYPE}.git
	git clone git://github.com/CyanogenMod/lge-kernel-star.git
fi

cd $KERNEL_DIR/${KERNEL_TYPE}

if ! test -f $KERNEL_DIR/${KERNEL_TYPE}/config.gz; then
	adb pull /proc/config.gz $KERNEL_DIR/${KERNEL_TYPE}/config.gz
fi

if ! test -f .config; then
	cat config.gz | gunzip > .config
fi

if [ "$1" == "clean" ]; then
	make clean
	make mrproper
	exit
fi

if [ "$1" == "oldconfig" ]; then
	make ARCH=arm CROSS_COMPILE=$CCOMPILER oldconfig
	exit
fi
if [ "$1" == "menuconfig" ]; then
	make ARCH=arm CROSS_COMPILE=$CCOMPILER menuconfig
	exit
fi

make ARCH=arm CROSS_COMPILE=$CCOMPILER -j`grep 'processor' /proc/cpuinfo | wc -l`

ls -l $KERNEL_DIR/${KERNEL_TYPE}/arch/arm/boot/zImage

#cd $CM_DIR/system/wlan/ti/sta_dk_4_0_4_32
#KERNEL_DIR=$KERNEL_DIR/${KERNEL_TYPE} CROSS_COMPILE=$CCOMPILER ARCH=arm make -j`grep 'processor' /proc/cpuinfo | wc -l`

if ! test -d $BOOT_DIR; then
	mkdir $BOOT_DIR
fi

cd $BOOT_DIR

split_bootimg.pl $CM_DIR/out/target/product/olympus/boot.img

if ! test -d $BOOT_DIR/ramdisk; then
	mkdir $BOOT_DIR/ramdisk
fi
cd $BOOT_DIR/ramdisk
gzip -dc ../boot.img-ramdisk.gz | cpio -i

cd $BOOT_DIR
$CM_DIR/out/host/linux-x86/bin/mkbootimg --cmdline 'mem=320M@0M nvmem=192M@320M mem=512M@512M vmalloc=320M video=tegrafb console=null usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=mbr:d00:100:800,kpanic:2100:400:800 security=tomoyo mot_prod=1 androidboot.serialno=TA2070KNGD' --kernel $KERNEL_DIR/${KERNEL_TYPE}/arch/arm/boot/zImage --ramdisk $BOOT_DIR/boot.img-ramdisk.gz -o boot.img

