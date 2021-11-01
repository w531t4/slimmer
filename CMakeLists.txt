cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(slimmer CXX)
set (APP_VERSION_NUMBER 1.2)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(ExternalProject)
include(cmake/zlib.cmake)
include(cmake/curl.cmake)
include(cmake/icu.cmake)
include(cmake/libev.cmake)
include(cmake/lcdapi.cmake)
include(cmake/tclap.cmake)
include(cmake/jsoncpp.cmake)
include(cmake/jsonrpccpp.cmake)
add_dependencies(jsonrpccpp-common jsoncpp)
add_dependencies(jsonrpccpp-client jsoncpp)
#################################################################################
# Libraries
#set(LIBS ${LIBS} /usr/local/lib)

#################################################################################
# Configuration files
string(TIMESTAMP BUILD_DATE UTC)

configure_file(
  "${PROJECT_SOURCE_DIR}/ApplicationInfo.h.in"
  "${CMAKE_CURRENT_BINARY_DIR}/ApplicationInfo.h"
  )
configure_file(
  "${PROJECT_SOURCE_DIR}/BuildInfo.h.in"
  "${CMAKE_CURRENT_BINARY_DIR}/BuildInfo.h"
  )

#################################################################################
# Executable
file(GLOB SRC_LIST
        "*.h"
        "*.cpp"
)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})
add_definitions(-flto -fuse-linker-plugin -pipe)

add_executable(${PROJECT_NAME} ${SRC_LIST})
target_link_libraries (${PROJECT_NAME} lcdapi icuuc icudata curl libev tclap jsoncpp jsonrpccpp-common jsonrpccpp-client)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

add_executable(${PROJECT_NAME}_static ${SRC_LIST})
target_link_libraries (${PROJECT_NAME}_static -static lcdapi_static icuuc_static icudata_static libev_static tclap jsoncpp_static jsonrpccpp-common_static jsonrpccpp-client_static curl_static zlib_static -lpthread)
set_property(TARGET ${PROJECT_NAME}_static PROPERTY CXX_STANDARD 11)
set_property(TARGET ${PROJECT_NAME}_static PROPERTY CXX_STANDARD_REQUIRED ON)


#################################################################################
# Clean
SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "ApplicationInfo.h;BuildInfo.h")

install(TARGETS slimmer)
install(TARGETS slimmer_static)