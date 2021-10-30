set(target lcdapi)
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS  ""
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/spdawson/lcdapi.git
        GIT_TAG v0.11
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        PATCH_COMMAND     "libtoolize"
                          "--force"
        COMMAND           "autoreconf"
                          "-i"
        CONFIGURE_COMMAND "<SOURCE_DIR>/configure"
                          "--prefix=<INSTALL_DIR>"
        BUILD_COMMAND   "make"
                        "-j4"
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/liblcdapi.so
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/liblcdapi.a
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

add_library(${target} SHARED IMPORTED)
set_target_properties(${target} PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/liblcdapi.so)
target_include_directories(${target} INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target} ${target}_external)

add_library(${target}_static STATIC IMPORTED)
set_target_properties(${target}_static PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/liblcdapi.a)
target_include_directories(${target}_static INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target}_static ${target}_external)
