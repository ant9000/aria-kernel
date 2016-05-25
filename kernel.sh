#!/bin/bash

set -e
BASE=$(dirname $(realpath $0))
cd $BASE

########################################
MAKE_ARGS="ARCH=arm CROSS_COMPILE=arm-linux-gnueabi-"
CPU_COUNT=`grep -c processor /proc/cpuinfo || true`
if [ $CPU_COUNT -gt 0 ]; then
  MAKE_ARGS="-j$CPU_COUNT $MAKE_ARGS"
fi

if [ ! -d build ]; then
  mkdir -p build
  cd linux-4.4.10/
  make mrproper
  make O=../build $MAKE_ARGS acme-aria_defconfig
  cd $BASE
fi

cd $BASE/build
if [ "x$1" == "xmenuconfig" ]; then
  make $MAKE_ARGS menuconfig
fi
make $MAKE_ARGS zImage modules
make $MAKE_ARGS acme-aria.dtb

rm -rf /vagrant/deploy
mkdir /vagrant/deploy
make $MAKE_ARGS modules_install INSTALL_MOD_PATH=/vagrant/deploy/
make $MAKE_ARGS firmware_install INSTALL_MOD_PATH=/vagrant/deploy/
mkdir /vagrant/deploy/boot/
cp arch/arm/boot/zImage /vagrant/deploy/boot/
cp arch/arm/boot/dts/acme-aria.dtb /vagrant/deploy/boot/at91-ariag25.dtb
