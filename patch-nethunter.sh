#!/bin/bash

KERNEL_VERSION="1.0"
NETHUNTER_KERNEL_DIR="kali-nethunter-kernel"
NETHUNTER_PROJECT_DIR="kali-nethunter-project"

if [ -d "$NETHUNTER_KERNEL_DIR" ]; then
    echo "[+] $NETHUNTER_KERNEL_DIR exits"
		cd $(pwd)/$NETHUNTER_KERNEL_DIR
    git pull
    cd ..
else
    echo "[!] $NETHUNTER_KERNEL_DIR not exits, start cloning..."
    git clone https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-kernel.git
fi

echo -n "[!] Adding patch add-rtl88xxau-5.6.4.2-drivers? [y/N]"
read -r add_rtl88xxau_drivers
if [ "$add_rtl88xxau_drivers" == "Y" ] || [ "$add_rtl88xxau_drivers" == "y" ]; then
    patch -p1 < kali-nethunter-kernel/patches/4.09/add-rtl88xxau-5.6.4.2-drivers.patch
fi

echo -n "[!] Adding patch add-wifi-injection-4.14.patch? [y/N]"
read -r add_wifi_injection
if [ "$add_wifi_injection" == "Y" ] || [ "$add_wifi_injection" == "y" ]; then
    patch -p1 < kali-nethunter-kernel/patches/4.09/add-wifi-injection-4.14.patch
fi

echo -n "[!] Adding patch fix-ath9k-naming-conflict.patch? [y/N]"
read -r fix_ath9k_naming_conflict
if [ "$fix_ath9k_naming_conflict" == "Y" ] || [ "$fix_ath9k_naming_conflict" == "y" ]; then
    patch -p1 < kali-nethunter-kernel/patches/4.09/fix-ath9k-naming-conflict.patch
fi

if [ -d "$NETHUNTER_PROJECT_DIR" ]; then
    echo "[+] $NETHUNTER_PROJECT_DIR exits"
    cd $(pwd)/$NETHUNTER_PROJECT_DIR
    git pull
    cd ..
else
    echo "[!] $NETHUNTER_PROJECT_DIR not exits, start cloning..."
    git clone https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-project --depth=1
fi

mkdir -p $(pwd)/$NETHUNTER_PROJECT_DIR/nethunter-installer/devices

cat << EOL > kali-nethunter-project/nethunter-installer/devices/devices.cfg
# Xiaomi 10 for LineageOS Android 14
[umi]
author = "Shetty Yttehs"
arch = arm64
version = "${KERNEL_VERSION}"
flasher = anykernel
modules = 1
slot_device = 0
block = /dev/block/bootdevice/by-name/boot
devicenames = umi,Mi10
EOL
