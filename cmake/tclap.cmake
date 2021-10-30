set(target tclap)
set(tclap_empty_tests_file "all:
@:
install:
@:
")
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/extras)
file(WRITE ${CMAKE_BINARY_DIR}/extras/empty_makefile "${tclap_empty_tests_file}")
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS ""
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/mirror/tclap.git
        GIT_TAG v1.2.4
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        PATCH_COMMAND     "libtoolize"
                          "--force"
        COMMAND           "autoreconf"
                          "-i"
        CONFIGURE_COMMAND "<SOURCE_DIR>/configure"
                          "--prefix=<INSTALL_DIR>"
        COMMAND         "rm"
                        "-rf"
                        <BINARY_DIR>/tests
                        <BINARY_DIR>/examples
        COMMAND         "mkdir"
                        "-p"
                        <BINARY_DIR>/tests
                        <BINARY_DIR>/examples
                        <BINARY_DIR>/docs/html
        COMMAND         "cp"
                        "${CMAKE_BINARY_DIR}/extras/empty_makefile"
                        <BINARY_DIR>/tests/Makefile
        COMMAND         "cp"
                        "${CMAKE_BINARY_DIR}/extras/empty_makefile"
                        <BINARY_DIR>/examples/Makefile
        BUILD_COMMAND   "make"
                        "-j4"
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>/docs/html
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

# INTERFACE used here because this lib is header-only
add_library(${target} INTERFACE)
target_include_directories(${target} INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target} ${target}_external)
