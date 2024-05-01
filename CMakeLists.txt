cmake_minimum_required(VERSION 3.5)

project(libmemleak VERSION 0.1.2 LANGUAGES C CXX)
set(PROJECT_VERSION ${PROJECT_VERSION}.2405A)

SET(CMAKE_INSTALL_PREFIX /usr)
include(GNUInstallDirs)


# TODO: Find an easy CMake variable telling the full TARGET arch
# will probably make this CMakeLists.txt only compatible with GCC - fine for now
execute_process(
    COMMAND ${CMAKE_C_COMPILER} -dumpmachine
    OUTPUT_VARIABLE TARGET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Variables used to generate config.h or *.pc file
# (TARGET is written as well)
set(PACKAGE ${PROJECT_NAME})
set(PACKAGE_VERSION ${PROJECT_VERSION})
set(VERSION ${PROJECT_VERSION})
# Need to determine the size of `time_t` type
include(CheckTypeSize)
check_type_size("time_t" SIZEOF_TIME_T)

# We need to declare the presence of the config.h and its location before
# adding the subdirectory ...
add_definitions("-DHAVE_CONFIG_H")
# config.h is located in the top folder, adding it to the include path here
include_directories(${CMAKE_CURRENT_BINARY_DIR})

add_subdirectory(src)

# ... but we need to generate the `config.h` file after to reflect some variables
# such as HAVE_PRINTF_STYLE_BFD_ERROR_HANDLER_TYPE
configure_file(config.h.cin config.h)

#
# Generate the pkg-config file
#
# need to define those variables for pkg-config file, hope we're not messing up
# with anything else
set(prefix ${CMAKE_INSTALL_PREFIX}) 
set(exec_prefix ${CMAKE_INSTALL_PREFIX}) 
set(libdir ${CMAKE_INSTALL_FULL_LIBDIR}) 
set(includedir ${CMAKE_INSTALL_FULL_INCLUDEDIR}) 

configure_file(
    ${PROJECT_NAME}.pc.in
    ${PROJECT_NAME}.pc
    @ONLY
)
install(
    FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc
    DESTINATION ${CMAKE_INSTALL_FULL_LIBDIR}/pkgconfig
)
install(
    PROGRAMS memleak_preload.sh
    DESTINATION ${CMAKE_INSTALL_FULL_BINDIR}
)

