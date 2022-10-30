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

# The following block determines if bfd_error_handler_type is defined in bfd*.h
# as a variadic function. This is a readaptation of cwm4's CW_TYPE_BFD_ERROR_HANDLER_TYPE.
if (BFD_LIBRARY)
    find_file(__BFD_HEADER bfd.h)
    find_file(__BFD32_HEADER bfd-32.h)
    find_file(__BFD64_HEADER bfd-64.h)
    EXECUTE_PROCESS(
                # All those commands are executed and piped to each other
                COMMAND grep bfd_error_handler_type ${__BFD_HEADER} ${__BFD32_HEADER} ${__BFD64_HEADER}
                COMMAND grep typedef
                COMMAND grep va_list
                OUTPUT_VARIABLE GREP_RESULTS
                ERROR_VARIABLE ERR)
    if (GREP_RESULTS)
        message(STATUS "bfd_error_handler_type is vprintf style (with a va_list parameter)")
    else()
        message(STATUS "bfd_error_handler_type is printf style")
        set(HAVE_PRINTF_STYLE_BFD_ERROR_HANDLER_TYPE "1" PARENT_SCOPE)
    endif()
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
