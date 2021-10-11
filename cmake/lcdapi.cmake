set(target lcdapi_external)
ExternalProject_add(
        ${target}
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
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target} INSTALL_DIR)
add_library(lcdapi SHARED IMPORTED)
#set_target_properties(lcdapi PROPERTIES IMPORTED_LOCATION ${CMAKE_BINARY_DIR}/build/${target}/src/${target}-install/lib/liblcdapi.so)
#file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/build/${target}/src/${target}-install/include)
#target_include_directories(lcdapi INTERFACE ${CMAKE_BINARY_DIR}/build/${target}/src/${target}-install/include)

set_target_properties(lcdapi PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/liblcdapi.so)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
target_include_directories(lcdapi INTERFACE ${INSTALL_DIR}/include)
add_dependencies(lcdapi ${target})
