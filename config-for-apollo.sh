#!/bin/sh

export CFLAGS="-funwind-tables -fasynchronous-unwind-tables"
export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables"

./autogen.sh

PATH_TOOLCHAIN=${PATH_OS}/arm-2011.09
export PATH=$PATH:${PATH_TOOLCHAIN}/bin
export CROSS_COMPILE=arm-none-linux-gnueabi-

mkdir -p build-armlinux
cd build-armlinux
../configure \
	--build=x86_64-linux \
	--host=arm-none-linux-gnueabi \
	--target=arm-none-linux-gnueabi \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--disable-dependency-tracking
	#--sysroot=${OS_PATH}/gcc-5.2/arm-unknown-linux-gnueabi/sysroot

cat config.h

