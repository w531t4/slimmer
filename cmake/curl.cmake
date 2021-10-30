set(target curl)
ExternalProject_add(
        ${target}_external
        CMAKE_ARGS  "-DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>"
                    "-DCURL_WERROR=OFF"
                    "-DENABLE_DEBUG=OFF"
                    "-DBUILD_CURL_EXE=OFF"
                    "-DBUILD_SHARED_LIBS=OFF"
                    #"-DCURL_STATICLIB=ON"
                    #"-DENABLE_SHARED=OFF"
                    #"-DENABLE_STATIC=ON"
                    "-DCURL_ENABLE_SSL=OFF"
                    "-DCURL_DISABLE_ALTSVC=YES"
                    "-DCURL_DISABLE_COOKIES=YES"
                    "-DCURL_DISABLE_CRYPTO_AUTH=YES"
                    "-DCURL_DISABLE_DICT=YES"
                    "-DCURL_DISABLE_DOH=YES"
                    "-DCURL_DISABLE_FILE=YES"
                    "-DCURL_DISABLE_FTP=YES"
                    "-DCURL_DISABLE_GETOPTIONS=YES"
                    "-DCURL_DISABLE_GOPHER=YES"
                    "-DCURL_DISABLE_HSTS=YES"
                    "-DCURL_DISABLE_HTTP=NO"
                    "-DCURL_DISABLE_HTTP_AUTH=YES"
                    "-DCURL_DISABLE_IMAP=YES"
                    "-DCURL_DISABLE_LDAP=YES"
                    "-DCURL_DISABLE_LDAPS=YES"
                    "-DCURL_DISABLE_LIBCURL_OPTION=YES"
                    "-DCURL_DISABLE_MIME=YES"
                    "-DCURL_DISABLE_MQTT=YES"
                    "-DCURL_DISABLE_NETRC=YES"
                    "-DCURL_DISABLE_NTLM=YES"
                    "-DCURL_DISABLE_PARSEDATE=YES"
                    "-DCURL_DISABLE_POP3=YES"
                    "-DCURL_DISABLE_NTLM=YES"
                    "-DCURL_DISABLE_PROGRESS_METER=YES"
                    "-DCURL_DISABLE_PROXY=YES"
                    "-DCURL_DISABLE_RTSP=YES"
                    "-DCURL_DISABLE_SHUFFLE_DNS=YES"
                    "-DCURL_DISABLE_SOCKETPAIR=YES"
                    "-DCURL_DISABLE_TELNET=YES"
                    "-DCURL_DISABLE_TFTP=YES"
                    "-DCURL_DISABLE_VERBOSE_STRINGS=YES"
                    "-DENABLE_IPV6=NO"

        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/curl/curl.git
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libcurl.a
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

add_library(${target}_static STATIC IMPORTED)
set_target_properties(${target}_static PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libcurl.a)
target_include_directories(${target}_static INTERFACE ${INSTALL_DIR}/include)
add_dependencies(${target}_static ${target}_external)

