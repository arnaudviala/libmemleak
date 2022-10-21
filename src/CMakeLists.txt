include(packages-deps.cmake)

# For libmemleak, we want to compile everything without optimization
# and with the following flags that will allow to have a nice backtrace()
add_compile_options(-funwind-tables -fasynchronous-unwind-tables -fno-omit-frame-pointer -U_FORTIFY_SOURCE -O0)

# Let's stop compilation on all warnings
add_compile_options(-Wall -Wextra -Werror)

# Option to enable the workaround to avoid a crash after combining intervals.
# /!\ Libmemleak functionality - ability to surface the leaking backtrace - is
# affected by this option. But it's better than a crash.
if (NO_COMBINE_INTERVAL)
add_definitions(-DNO_COMBINE_INTERVAL)
endif()

#
# `libmemleak` library
#

add_subdirectory(rb_tree)

# TODO: With CMake, it's a complicated to build both a Static and Shared library
# With recent version of cmake, we can achieve this using a intermediate "Object Lib"
# but this fails with old versions of cmake (such as Vulcan's BSP one)
# For now, use SHARED for now. We may give the option to have SHARED or STATIC later.
set(LIBRARY_LINK_TYPE SHARED)

add_library(memleak ${LIBRARY_LINK_TYPE}
    "memleak.c"
    "sort.c"
    "addr2line.c"
    )

set_property(TARGET memleak PROPERTY POSITION_INDEPENDENT_CODE 1)

set_target_properties(memleak PROPERTIES
    VERSION 0.0.3
    SOVERSION 0
    )

target_include_directories(memleak PRIVATE
    "include"
    ${BFD_INCLUDE_DIR}
    )
target_link_libraries(memleak PRIVATE rbtree)
if (BFD_LIBRARY)
    target_link_libraries(memleak PRIVATE ${BFD_LIBRARY})
else()
    # using a WITHOUT_BFD rather than HAVE_BFD to avoid adding
    # a similar mechanism to the `configure.ac`
    add_definitions("-DWITHOUT_BFD")
endif()

install(TARGETS memleak
    LIBRARY DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR})

#
# `memleak_control` program
#
add_executable(memleak_control memleak_control.c)

install(TARGETS memleak_control
    RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})

target_include_directories(memleak_control PRIVATE ${READLINE_INCLUDE_DIR})
if (READLINE_LIBRARY)
    target_link_libraries(memleak_control PRIVATE ${READLINE_LIBRARY})
else()
    # using a WITHOUT_READLINE rather than HAVE_READLINE to avoid adding
    # a similar mechanism to the `configure.ac`
    add_definitions("-DWITHOUT_READLINE")
endif()

#
# `memleak_hello` program
#
add_executable(memleak_hello hello.cc)
target_include_directories(memleak_hello PRIVATE "include")

target_link_libraries(memleak_hello PRIVATE Threads::Threads)

install(TARGETS memleak_hello
    RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})

#
# `check_backtrace` program
#
add_executable(check_backtrace check_backtrace.c)
target_include_directories(check_backtrace PRIVATE ${OPENSSL_INCLUDE_DIR})

target_link_libraries(check_backtrace PRIVATE
    ${OPENSSL_LIBRARIES}
    ${CMAKE_DL_LIBS}
    )

install(TARGETS check_backtrace
    RUNTIME DESTINATION ${CMAKE_INSTALL_FULL_BINDIR})
