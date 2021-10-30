set(target jsoncpp)
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
        GIT_TAG 1.9.4
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libjsoncpp.so
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libjsoncpp_static.a
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

add_library(${target} SHARED IMPORTED)
set_target_properties(${target} PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsoncpp.so)
target_include_directories(${target} INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target} ${target}_external)

add_library(${target}_static STATIC IMPORTED)
set_target_properties(${target}_static PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsoncpp_static.a)
target_include_directories(${target}_static INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target}_static ${target}_external)
