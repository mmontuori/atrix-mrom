
source setenv

init_repo

if [ "$1" == "" ]; then
	echo "makebootimg.sh {zimage file}"
	exit 1
fi

export ZIMAGE=$1

if ! test -d $BOOT_DIR; then
	mkdir $BOOT_DIR
fi

cd $BOOT_DIR

split_bootimg.pl $SYS_DIR/out/target/product/olympus/boot.img

if ! test -d $BOOT_DIR/ramdisk; then
	mkdir $BOOT_DIR/ramdisk
fi
cd $BOOT_DIR/ramdisk
gzip -dc ../boot.img-ramdisk.gz | cpio -i

cd $BOOT_DIR
$SYS_DIR/out/host/linux-x86/bin/mkbootimg --cmdline 'mem=320M@0M nvmem=192M@320M mem=512M@512M vmalloc=320M video=tegrafb console=null usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=mbr:d00:100:800,kpanic:2100:400:800 security=tomoyo mot_prod=1 androidboot.serialno=TA2070KNGD' --kernel $ZIMAGE --ramdisk $BOOT_DIR/boot.img-ramdisk.gz -o boot.img

