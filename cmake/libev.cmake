set(target libev)
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS  ""
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/xorangekiller/libev-git.git
        GIT_TAG "rel-4_33"
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        PATCH_COMMAND      "chmod"
                           "+x"
                           "<SOURCE_DIR>/autogen.sh"
        COMMAND            "<SOURCE_DIR>/autogen.sh"
        CONFIGURE_COMMAND  "<SOURCE_DIR>/configure"
                           "--prefix=<INSTALL_DIR>"
                           "--includedir=<INSTALL_DIR>/include/libev"
                           "--disable-static"
        BUILD_COMMAND      "make"
                           "-j4"
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libev.so
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>/include/libev
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

add_library(${target} SHARED IMPORTED)
set_target_properties(${target} PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libev.so)
target_include_directories(${target} INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target} ${target}_external)
