ExternalProject_Get_property(jsoncpp_external INSTALL_DIR)
set(jsoncpp_installdir "${INSTALL_DIR}")
set(target jsonrpccpp)
ExternalProject_add(
        ${target}_external
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
        GIT_TAG v1.4.0
        # i believe this tag occurred @/around original implementation
        #GIT_TAG fe44ed8eb8db00099119af66479bc182e4d92e70
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        #UPDATE_COMMAND ""
        PATCH_COMMAND
                git apply ${CMAKE_CURRENT_LIST_DIR}/patches/jsonrpccpp.patch || true

)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

add_library(${target}-common SHARED IMPORTED)
set_target_properties(${target}-common PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-common.so)
add_dependencies(${target}-common ${target}_external)
target_include_directories(${target}-common INTERFACE ${INSTALL_DIR}/include)

add_library(${target}-client SHARED IMPORTED)
set_target_properties(${target}-client PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-client.so)
add_dependencies(${target}-client ${target}_external)

add_library(${target}-server SHARED IMPORTED)
set_target_properties(${target}-server PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-server.so)
add_dependencies(${target}-server ${target}_external)
