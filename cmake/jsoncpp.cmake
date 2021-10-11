set(target jsoncpp_external)
ExternalProject_add(
        ${target}
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/open-source-parsers/jsoncpp.git
        GIT_TAG 1.9.4
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libjsoncpp.so
)
ExternalProject_Get_property(${target} INSTALL_DIR)
add_library(jsoncpp SHARED IMPORTED)
set_target_properties(jsoncpp PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsoncpp.so)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
target_include_directories(jsoncpp INTERFACE ${INSTALL_DIR}/include)
add_dependencies(jsoncpp ${target})
