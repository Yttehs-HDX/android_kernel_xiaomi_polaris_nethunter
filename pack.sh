#!/bin/bash

#  _   _      _   _   _             _            
# | \ | | ___| |_| | | |_   _ _ __ | |_ ___ _ __ 
# |  \| |/ _ \ __| |_| | | | | '_ \| __/ _ \ '__|
# | |\  |  __/ |_|  _  | |_| | | | | ||  __/ |   
# |_| \_|\___|\__|_| |_|\__,_|_| |_|\__\___|_|

NETHUNTER_PROJECT="kali-nethunter-project"
O="out"
ARCH="arm64"

DEVICE="polaris"
ANDROID_VERSION="thirteen" # kali nethunter only support android 13 and below
POLARIS="$(pwd)/$NETHUNTER_PROJECT/nethunter-installer/devices/$ANDROID_VERSION/$DEVICE"

mkdir -p ${POLARIS}/modules/system/lib/modules

echo "[!] clean old files"
rm -rf ${POLARIS}/Image
rm -rf ${POLARIS}/Image.gz
rm -rf ${POLARIS}/Image.gz-dtb
rm -rf ${POLARIS}/dtbo.img
rm -rf ${POLARIS}/dtb
rm -rf ${POLARIS}/modules/system/lib/modules/*

echo "[+] add kernel image"
cp ${O}/arch/${ARCH}/boot/Image ${POLARIS}/Image
cp ${O}/arch/${ARCH}/boot/Image.gz ${POLARIS}/Image.gz
cp ${O}/arch/${ARCH}/boot/Image.gz-dtb ${POLARIS}/Image.gz-dtb

cp -r $(pwd)/$O/lib/modules/* ${POLARIS}/modules/system/lib/modules/

cd $(pwd)/${NETHUNTER_PROJECT}/nethunter-installer/
python3 build.py -d polaris --thirteen --kernel
