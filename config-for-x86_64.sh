#!/bin/sh

#export CFLAGS="-funwind-tables -fasynchronous-unwind-tables"
#export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables"

# autogen.sh is broken, it's downloading the latest version
# of author's `cwm4` tools which are not necessarily compatible
# with what we have
# ./autogen.sh
# Do the following manually: (once?)
# > git submodule update --init
# > $PWD/cwm4/scripts/generate_submodules_m4.sh
# > $PWD/cwm4/scripts/bootstrap.sh

TARGET=`gcc -dumpmachine`

	#--build=x86_64-linux \
	#--host=x86_64-linux \

mkdir -p build-x86_64
cd build-x86_64
../configure \
	--build=${TARGET} \
	--host=${TARGET} \
	--target=${TARGET} \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib64 \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--disable-dependency-tracking

cat config.h
