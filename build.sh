#!/bin/bash

#     _              _           _     _   _                        _ 
#    / \   _ __   __| |_ __ ___ (_) __| | | | _____ _ __ _ __   ___| |
#   / _ \ | '_ \ / _` | '__/ _ \| |/ _` | | |/ / _ \ '__| '_ \ / _ \ |
#  / ___ \| | | | (_| | | | (_) | | (_| | |   <  __/ |  | | | |  __/ |
# /_/   \_\_| |_|\__,_|_|  \___/|_|\__,_| |_|\_\___|_|  |_| |_|\___|_|

# +---------------------------------+
# | Build script for Android kernel | 
# | Author: Yttehs-HDX@Github	      |
# +---------------------------------+

# kernel
DEFCONFIG="polaris-miku_defconfig"
O="out"
ARCH="arm64"

# clang
#  
# ├──  kernel_root
# └──  toolchains
CLANG_VERSION="20"
CLANG_PATH="$(pwd)/../toolchains/zyc-${CLANG_VERSION}"
PATH="$PATH:${CLANG_PATH}/bin"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# clean environment
echo -e "${YELLOW}-> make mrproper ...${RESET}"
rm -rf $O
make mrproper

# build kernel
echo -e "${YELLOW}-> make ${DEFCONFIG} ...${RESET}"
make O=$O ARCH=$ARCH $DEFCONFIG

echo -e "${BLUE}=> CLANG_PATH = ${CLANG_PATH}${RESET}"
echo -e "${YELLOW}-> make ...${RESET}"
make -j$(nproc --all) O=$O \
                      ARCH=$ARCH \
                      CC=clang \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE=aarch64-linux-gnu- \
                      CROSS_COMPILE_ARM32=arm-linux-gnueabi \
                      CFLAGS_KERNEL=-Wno-error \
                      KCFLAGS=-Wno-error

echo -e "${YELLOW}-> make modules ...${RESET}"
make modules_install INSTALL_MOD_PATH="." \
                     INSTALL_MOD_STRIP=1 \
                     O=$O \
                     ARCH=$ARCH \
                     CC=clang \
                     CLANG_TRIPLE=aarch64-linux-gnu- \
                     CROSS_COMPILE=aarch64-linux-gnu- \
                     CROSS_COMPILE_ARM32=arm-linux-gnueabi \
                     CFLAGS_KERNEL=-Wno-error \
                     KCFLAGS=-Wno-error
