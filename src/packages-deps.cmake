# Detect libpthread
find_package(Threads REQUIRED)

# Binutils/BFD
if (BFD_LIBRARY)
    message("-- Given BFD as: ${BFD_LIBRARY}")
else()
    find_library(BFD_LIBRARY bfd)
    if (BFD_LIBRARY)
        message("-- Found BFD: ${BFD_LIBRARY}")
    else()
        message("-- Cannot find BFD library")
    endif()
endif()

# The following block determines if bfd_error_handler_type is defined in bfd.h
# as a variadic function. This is a readaptation of cwm4's CW_TYPE_BFD_ERROR_HANDLER_TYPE.
find_file(__BFD_HEADER bfd.h)
SET(GREP_ARGS -o typedef[^\\*]\*\\*bfd_error_handler_type\)[^.]\*\.\.\.\) ${__BFD_HEADER})
EXECUTE_PROCESS(
            COMMAND
            grep ${GREP_ARGS}
            OUTPUT_VARIABLE GREP_RESULTS
            ERROR_VARIABLE ERR)
if (GREP_RESULTS)
    message(STATUS "bfd_error_handler_type is printf style")
    set(HAVE_PRINTF_STYLE_BFD_ERROR_HANDLER_TYPE "1" PARENT_SCOPE)
endif()

# Readline library
if (READLINE_LIBRARY)
    message("-- Given Readline as: ${READLINE_LIBRARY}")
else()
    find_library(READLINE_LIBRARY readline)
    if (READLINE_LIBRARY)
        message("-- Found Readline: ${READLINE_LIBRARY}")
    else()
        message("-- Cannot find READLINE library")
    endif()
endif()

# OpenSSL library
if (OPENSSL_LIBRARIES)
    message("-- OpenSSL libraries are given as: ${OPENSSL_LIBRARIES}")
else()
    set(OPENSSL_MIN_VERSION 1.1.1)
    find_package(OpenSSL ${OPENSSL_MIN_VERSION})
    # message("Found OpenSSL: ${OPENSSL_LIBRARIES}")
endif()
