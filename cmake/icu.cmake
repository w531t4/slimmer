set(target icu)
ExternalProject_add(
        ${target}_external
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
        # use '--enable-tracing' to identify exactly what you're using
        CONFIGURE_COMMAND
                ${CMAKE_COMMAND} -E env
                VERBOSE=1
                ICU_DATA_FILTER_FILE=${CMAKE_CURRENT_LIST_DIR}/patches/icu-filter.json
                "<SOURCE_DIR>/icu4c/source/configure"
                "--prefix=<INSTALL_DIR>"
                "--disable-tests"
                "--enable-static"
                "--disable-samples"
                "--disable-renaming"
                "--disable-extras"
                "--disable-dyload"
                "--disable-icu-config"
                #"--enable-tracing"
                "--enable-rpath"
        BUILD_COMMAND
                make -j4 VERBOSE=1
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libicuuc.so
                         <INSTALL_DIR>/lib/libicudata.so
                         <INSTALL_DIR>/lib/libicuuc.a
                         <INSTALL_DIR>/lib/libicudata.a
        INSTALL_COMMAND "mkdir"
                        "-p"
                        <INSTALL_DIR>
        COMMAND         "make"
                        "install"
)
ExternalProject_Get_property(${target}_external INSTALL_DIR)
file(MAKE_DIRECTORY ${INSTALL_DIR}/include)
add_library(${target}uc SHARED IMPORTED)
set_target_properties(${target}uc PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicuuc.so
                        )
target_include_directories(${target}uc INTERFACE ${INSTALL_DIR}/include)

add_library(${target}data SHARED IMPORTED)
set_target_properties(${target}data PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicudata.so
                        )
target_include_directories(${target}data INTERFACE ${INSTALL_DIR}/include)

add_library(${target}uc_static STATIC IMPORTED)
set_target_properties(${target}uc_static PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicuuc.a
                        )
target_include_directories(${target}uc_static INTERFACE ${INSTALL_DIR}/include)

add_library(${target}data_static STATIC IMPORTED)
set_target_properties(${target}data_static PROPERTIES
                        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libicudata.a
                        )
target_include_directories(${target}data_static INTERFACE ${INSTALL_DIR}/include)


add_dependencies(${target}uc ${target}_external)
add_dependencies(${target}data ${target}_external)
add_dependencies(${target}uc ${target}data)

add_dependencies(${target}uc_static ${target}_external)
add_dependencies(${target}data_static ${target}_external)
add_dependencies(${target}uc_static ${target}data_static)
