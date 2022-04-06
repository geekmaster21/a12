#!/usr/bin/env bash
# Copyright ©2021 - 2022 XSans02
# Docker Kernel Build Script

# Installing some dep
sudo apt-get install cpio libtinfo5

git clone --depth=1 https://github.com/kdrag0n/proton-clang clang
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 gcc
# Setup Environtment
KERNEL_DIR=/home/ubuntu/SM-A715F_HK_12_Opensource
DEVICE=a71
DEFCONFIG="$DEVICE"_defconfig
export ARCH="arm64"
export SUBARCH="arm64"
export KBUILD_BUILD_USER="Geekmaster21"
export KBUILD_BUILD_HOST="OVH"
CLANG_DIR="$KERNEL_DIR/clang"
GCC_DIR="$KERNEL_DIR/gcc"
export PATH="$CLANG_DIR/bin:$GCC_DIR/bin:$PATH"
export KBUILD_COMPILER_STRING="$("$CLANG_DIR"/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')"
KERNEL_MAKE_ENV="DTC_EXT=$KERNEL_DIR/tools/dtc CONFIG_BUILD_ARM64_DT_OVERLAY=y"

make O=out ARCH=arm64 "$DEFCONFIG"

make -j$(nproc --all) O=out LLVM=1 ARCH=arm64 $KERNEL_MAKE_ENV \
            SUBARCH=arm64 \
            LD_LIBRARY_PATH="${CLANG_DIR}/lib:${LD_LIBRARY_PATH}" \
            CC=clang \
            AR=llvm-ar \
            NM=llvm-nm \
            OBJCOPY=llvm-objcopy \
            OBJDUMP=llvm-objdump \
            STRIP=llvm-strip \
            LD=ld.lld \
            CLANG_TRIPLE=aarch64-linux-gnu- \
            CROSS_COMPILE=$GCC_DIR/bin/aarch64-linux-androidkernel-
