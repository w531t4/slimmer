set(target icu_external)
ExternalProject_add(
        ${target}
        CMAKE_ARGS  ""
        LOG_CONFIGURE 1
        LOG_BUILD 1
        GIT_REPOSITORY https://github.com/unicode-org/icu.git
        GIT_TAG release-69-1
        GIT_PROGRESS 1
        BUILD_IN_SOURCE 0
        UPDATE_COMMAND ""
        PATCH_COMMAND
                sed -i -e "s:LDFLAGSICUDT=-nodefaultlibs -nostdlib:LDFLAGSICUDT=:" <SOURCE_DIR>/icu4c/source/config/mh-linux
        COMMAND
                sed -i -e "s/#define U_DISABLE_RENAMING 0/#define U_DISABLE_RENAMING 1/" <SOURCE_DIR>/icu4c/source/common/unicode/uconfig.h
        CONFIGURE_COMMAND
                ${CMAKE_COMMAND} -E env
                #VERBOSE=1
                "<SOURCE_DIR>/icu4c/source/configure"
                "--prefix=<INSTALL_DIR>"
                "--disable-tests"
                "--disable-samples"
                "--disable-renaming"
                "--disable-extras"
                "--disable-dyload"
                "--disable-icu-config"
                "--enable-rpath"
        BUILD_COMMAND
                make -j4 VERBOSE=1
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libicuuc.so
                         <INSTALL_DIR>/lib/libicudata.so
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target} INSTALL_DIR)
add_library(icuuc SHARED IMPORTED)
add_library(icudata SHARED IMPORTED)
set_target_properties(icuuc PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicuuc.so
                        )
set_target_properties(icudata PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicudata.so
                        )
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
target_include_directories(icuuc INTERFACE ${INSTALL_DIR}/include)
target_include_directories(icudata INTERFACE ${INSTALL_DIR}/include)
add_dependencies(icuuc ${target})
add_dependencies(icudata ${target})
add_dependencies(icuuc icudata)
