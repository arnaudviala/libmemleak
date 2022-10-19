#!/bin/sh


PATH_TO_VOS_SDKS="${HOME}/firmware/os/vos/sdk"
PATH_TO_EOS="${HOME}/firmware/os/eos"


_find_latest_lxsim_env()
{
    local prefix="/opt/gcc-"
    env=$(find ${prefix}* -name "env.sh" | sed "s,${prefix},,g" | sort -g -r | head -n 1)
    echo ${prefix}${env}
}

build_product()
{
    local platform=$1
    local cmake_opts=
    case $platform in
    "mt8518"|"ares"|"vulcan"|"theia")
        echo "Sourcing the Yocto environment for $platform..."
        source ${PATH_TO_VOS_SDKS}/${platform}/out/setup-env.sh
        ;;
    "asteria")
        echo "Platform $platform is unsupported for now"
        return 1
        ;;
    "lxsim")
        local env=$(_find_latest_lxsim_env)
        if [ -r "$env" ]; then
            echo "Sourcing $(dirname ${env}) environment for $platform..."
            source ${env}
            export CC=gcc
            export CXX=g++
        else
            echo "Cannot find any /opt/gcc-* environment"
        fi
        ;;
    "imx28")
        local EOS_TOOLCHAIN="gcc-5.2"
        local TOOLCHAIN_PATH=${PATH_TO_EOS}/${EOS_TOOLCHAIN}/bin
        export CC=$(find ${TOOLCHAIN_PATH} -name "*-gcc")
        export CXX=$(find ${TOOLCHAIN_PATH} -name "*-g++")
        export PATH=$PATH:${TOOLCHAIN_PATH}
        # with eos, cmake will fail to find OpenSSL, let's give it directly
        local openssl_dir=$(find ${PATH_TO_EOS}/out -maxdepth 1 -name "openssl-*")
        local libssl=$(find ${openssl_dir} -name "libssl.so")
        local libcrypto=$(find ${openssl_dir} -name "libcrypto.so")
        cmake_opts="${cmake_opts} -DOPENSSL_LIBRARIES=${libssl};${libcrypto} -DOPENSSL_INCLUDE_DIR=${openssl_dir}/include"
        # TODO: same for libreadline (when it is ready)
        # local readline_dir=$(find ${PATH_TO_EOS}/out -maxdepth 1 -name "readline")
        # local libreadline=$(find ${readline_dir} -name "libreadline.so")
        # cmake_opts="${cmake_opts} -DREADLINE_LIBRARY=${libreadline} -DREADLINE_INCLUDE_DIR=${readline_dir}/include"
        # TODO: same for libbfd (when it is ready)
        ;;
    *)
        echo "Platform $platform is unhandled"
        return 1
        ;;
    esac
    echo "For $platform: using CC=\"$CC\""


    # Fix cmake invocation
    CMAKE="cmake"
    if [ -n "${OE_CMAKE_TOOLCHAIN_FILE}" ]; then
        CMAKE="${CMAKE}"
    elif [ -f "${PATH_TO_VOS_SDKS}/${platform}/out/sysroots/x86_64-oesdk-linux/usr/share/cmake/OEToolchainConfig.cmake" ]; then
        CMAKE="${CMAKE} -DCMAKE_TOOLCHAIN_FILE=${PATH_TO_VOS_SDKS}/${platform}/out/sysroots/x86_64-oesdk-linux/usr/share/cmake/OEToolchainConfig.cmake"
    fi

    local builddir=build/${platform}/
    # Old versions of cmake (at least, Vulcan's one) do not like the following ...
    # cmake -B ${builddir} -S .
    # ... replacing with the old invocation (which still works with newer cmake)
    mkdir -p ${builddir}
    cd ${builddir}
    ${CMAKE} ../.. ${cmake_opts}
    # `make install` will compile and install in one command
    make -j8 install DESTDIR=../../staging/${platform}
}

main()
{
    local PLATFORMS="mt8518 theia asteria vulcan imx28 lxsim"
    if [ -n "$*" ]; then
        PLATFORMS="$*"
    fi

    for platform in ${PLATFORMS}; do

        # build each product in a "new" shell, so Yocto environment don't pollute each
        # other
        (build_product $platform)

    done
}

main $@