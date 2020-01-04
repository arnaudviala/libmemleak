#!/bin/sh

export CFLAGS="-funwind-tables -fasynchronous-unwind-tables"
export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables"

./autogen.sh

mkdir -p build-cortexa7hf
cd build-cortexa7hf
../configure \
	--build=x86_64-linux \
	--host=arm-poky-linux-gnueabi \
	--target=arm-poky-linux-gnueabi \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--disable-dependency-tracking \
	--with-libtool-sysroot=$SDKTARGETSYSROOT

cat config.h
