#!/bin/sh

# first draft, the PROG_TO_RUN is the param $1
# TODO: a more elaborated code if we add CLI-options to the script
PROG_TO_RUN=$1
shift
PROG_ARGS=$@

SYSTEM_DIRS="/lib /usr/lib"
# prefer to search 64-bits path if present
if [ -d /lib64 ]; then SYSTEM_DIRS="/lib64 /usr/lib64"; fi

# TODO: ideally, `so` libraries are versioned and libmemleak is associated with
# one particular version. Instead of looking for libfoo.so.[0-9], we should look
# for the specific version.
machine=`uname -m`
# memleak could be installed in various places...
# (`find ... -print -quit` will return the first match only)
[ -z $LIBMEMLEAK ] && LIBMEMLEAK=$(find staging-$machine ${SYSTEM_DIRS} /config -name "libmemleak.so*" -print -quit 2>/dev/null)
[ -z $LIBDL ] && LIBDL=$(find ${SYSTEM_DIRS} -name "libdl.so.[0-9]" -print -quit 2>/dev/null)
[ -z $LIBBFD ] && LIBBFD=$(find ${SYSTEM_DIRS} -name "libbfd*.so" -print -quit 2>/dev/null)
[ -z $LIBPTHREAD ] && LIBPTHREAD=$(find ${SYSTEM_DIRS} -name "libpthread.so.[0-9]" -print -quit 2>/dev/null)

echo "Preloading:"
echo " - ${LIBMEMLEAK}"
echo " - ${LIBDL}"
echo " - ${LIBBFD}"
echo " - ${LIBPTHREAD}"
echo "Running:"
echo " - prog: ${PROG_TO_RUN}"
echo " - args: ${PROG_ARGS}"
echo ""

export LD_PRELOAD="${LIBMEMLEAK} ${LIBDL} ${LIBBFD} ${LIBPTHREAD}"
exec \
	${PROG_TO_RUN} \
	${PROG_ARGS}
