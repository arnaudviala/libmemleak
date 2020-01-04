#!/bin/sh

export CFLAGS="-funwind-tables -fasynchronous-unwind-tables"
export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables"

./autogen.sh

mkdir -p build-aarch64
cd build-aarch64
../configure \
	--build=x86_64-linux \
	--host=aarch64-poky-linux \
	--target=aarch64-poky-linux \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib64 \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--disable-dependency-tracking \
	--with-libtool-sysroot=$SDKTARGETSYSROOT

cat config.h
