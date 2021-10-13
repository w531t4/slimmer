ExternalProject_Get_property(jsoncpp_external INSTALL_DIR)
set(jsoncpp_installdir "${INSTALL_DIR}")
set(target jsonrpccpp_external)
ExternalProject_add(
        ${target}
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
                   "-DCOMPILE_TESTS=NO"
                   "-DCOMPILE_STUBGEN=NO"
                   "-DCOMPILE_EXAMPLES=NO"
                   "-DHTTP_SERVER=NO"
                   "-DHTTP_CLIENT=YES"
                   "-DREDIS_SERVER=NO"
                   "-DREDIS_CLIENT=NO"
                   "-DUNIX_DOMAIN_SOCKET_SERVER=NO"
                   "-DUNIX_DOMAIN_SOCKET_CLIENT=NO"
                   "-DFILE_DESCRIPTOR_SERVER=NO"
                   "-DFILE_DESCRIPTOR_CLIENT=NO"
                   "-DTCP_SOCKET_SERVER=NO"
                   "-DTCP_SOCKET_CLIENT=NO"
                   "-DJSONCPP_INCLUDE_DIR=${jsoncpp_installdir}/include"
                   "-DJSONCPP_LIBRARY=${jsoncpp_installdir}/lib/libjsoncpp.so"
        DEPENDS jsoncpp_external
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/cinemast/libjson-rpc-cpp.git
        #GIT_TAG v1.3.0 <-- latest tag
        #GIT_TAG fe44ed8eb8db00099119af66479bc182e4d92e70 is between v0.5.0 and v0.7.0
        GIT_TAG fe44ed8eb8db00099119af66479bc182e4d92e70
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        #UPDATE_COMMAND ""
        PATCH_COMMAND
                git apply ${CMAKE_CURRENT_LIST_DIR}/patches/jsonrpccpp.patch
)
ExternalProject_Get_property(${target} INSTALL_DIR)
add_library(jsonrpccpp-common SHARED IMPORTED)
add_library(jsonrpccpp-client SHARED IMPORTED)
add_library(jsonrpccpp-server SHARED IMPORTED)
set_target_properties(jsonrpccpp-common PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-common.so)
set_target_properties(jsonrpccpp-client PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-client.so)
set_target_properties(jsonrpccpp-server PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-server.so)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
target_include_directories(jsonrpccpp-common INTERFACE ${INSTALL_DIR}/include)
add_dependencies(jsonrpccpp-common ${target})
add_dependencies(jsonrpccpp-client ${target})
add_dependencies(jsonrpccpp-server ${target})
