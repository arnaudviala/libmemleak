#!/bin/sh

export CFLAGS="-funwind-tables -fasynchronous-unwind-tables"
export LDFLAGS="-funwind-tables -fasynchronous-unwind-tables"

export CFLAGS="-DWITHOUT_READLINE"
export CLFAGS="-DNO_COMBINE_INTERVAL"
export CFLAGS="-DWITHOUT_BFD"

# autogen.sh is broken, it's downloading the latest version
# of author's `cwm4` tools which are not necessarily compatible
# with what we have
# ./autogen.sh
# Do the following manually: (once?)
# > git submodule update --init
# > $PWD/cwm4/scripts/generate_submodules_m4.sh
# > $PWD/cwm4/scripts/bootstrap.sh

#PATH_TOOLCHAIN=${PATH_OS}/arm-2011.09
PATH_TOOLCHAIN=${PATH_OS}/gcc-5.2/bin
export PATH=$PATH:${PATH_TOOLCHAIN}/bin
#export CROSS_COMPILE=arm-none-linux-gnueabi-
export CROSS_COMPILE=arm-unknown-linux-gnueabi-

mkdir -p build-mx28
cd build-mx28
../configure \
	--build=x86_64-linux \
	--host=arm-unknown-linux-gnueabi \
	--target=arm-unknown-linux-gnueabi \
	--prefix=/usr --exec_prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin \
	--libexecdir=/usr/libexec --datadir=/usr/share --sysconfdir=/etc \
	--sharedstatedir=/com --localstatedir=/var --libdir=/usr/lib \
	--includedir=/usr/include --oldincludedir=/usr/include \
	--infodir=/usr/share/info --mandir=/usr/share/man \
	--disable-silent-rules \
	--enable-debug \
	--disable-dependency-tracking
	#--sysroot=${OS_PATH}/gcc-5.2/arm-unknown-linux-gnueabi/sysroot

cat config.h

# fix cruU -> cru because M28 `ar` is super old :(
sed -i -e s/cruU/cru/g Makefile src/Makefile src/include/Makefile arm-none-linux-gnueabi-libtool src/rb_tree/Makefile


