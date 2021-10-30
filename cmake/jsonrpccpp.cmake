ExternalProject_Get_property(jsoncpp_external INSTALL_DIR)

set(jsoncpp_installdir "${INSTALL_DIR}")
ExternalProject_Get_property(curl_external INSTALL_DIR)
set(curl_installdir "${INSTALL_DIR}")
set(target jsonrpccpp)
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
                   "-DBUILD_STATIC_LIBS=YES"
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
                   "-DWITH_COVERAGE=NO"
                   "-DJSONCPP_INCLUDE_DIR=${jsoncpp_installdir}/include"
                   "-DJSONCPP_LIBRARY=${jsoncpp_installdir}/lib/libjsoncpp.so"
                   "-DCURL_INCLUDE_DIR=${curl_installdir}/include"
                   "-DCURL_LIBRARY=${curl_installdir}/lib"
        DEPENDS jsoncpp_external curl_external
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/cinemast/libjson-rpc-cpp.git
        GIT_TAG v1.4.0
        # i believe this tag occurred @/around original implementation
        #GIT_TAG fe44ed8eb8db00099119af66479bc182e4d92e70
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        PATCH_COMMAND
                git apply ${CMAKE_CURRENT_LIST_DIR}/patches/jsonrpccpp.patch || true
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libjsonrpccpp-server.so
                         <INSTALL_DIR>/lib/libjsonrpccpp-common.so
                         <INSTALL_DIR>/lib/libjsonrpccpp-client.so
                         <INSTALL_DIR>/lib/libjsonrpccpp-server.a
                         <INSTALL_DIR>/lib/libjsonrpccpp-common.a
                         <INSTALL_DIR>/lib/libjsonrpccpp-client.a

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


add_library(${target}-common_static SHARED IMPORTED)
set_target_properties(${target}-common_static PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-common.a)
target_include_directories(${target}-common_static INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target}-common_static ${target}_external)


add_library(${target}-client_static SHARED IMPORTED)
set_target_properties(${target}-client_static PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-client.a)
add_dependencies(${target}-client_static ${target}_external)

add_library(${target}-server_static SHARED IMPORTED)
set_target_properties(${target}-server_static PROPERTIES
                      IMPORTED_LOCATION ${INSTALL_DIR}/lib/libjsonrpccpp-server.a)

add_dependencies(${target}-server_static ${target}_external)
