#!/bin/sh

export CFLAGS="-funwind-tables -fasynchronous-unwind-tables -fno-omit-frame-pointer -U_FORTIFY_SOURCE -O0"
export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables -fno-omit-frame-pointer"

# autogen.sh is broken, it's downloading the latest version
# of author's `cwm4` tools which are not necessarily compatible
# with what we have
# ./autogen.sh
# Do the following manually: (once?)
# > git submodule update --init
# > $PWD/cwm4/scripts/generate_submodules_m4.sh
# > $PWD/cwm4/scripts/bootstrap.sh

TARGET=`$CC -dumpmachine`

mkdir -p build-mt8518
cd build-mt8518
../configure \
	--build=x86_64-linux \
	--host=${TARGET} \
	--target=${TARGET} \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--disable-dependency-tracking \
	--with-libtool-sysroot=$SDKTARGETSYSROOT

cat config.h
