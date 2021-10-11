cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(slimmer CXX)
set (APP_VERSION_NUMBER 1.2)
include(ExternalProject)
include(cmake/libev.cmake)
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
file(GLOB_RECURSE JSONRPCCPP_LIST
        "jsonrpccpp/*.h"
        "jsonrpccpp/*.cpp"
)

file(GLOB_RECURSE JSONCPP_LIST
        "json/*.h"
        "json/*.cpp"
)

file(GLOB_RECURSE LCDAPI_LIST
        "lcdapi/*.h"
)

file(GLOB_RECURSE TCLAP_LIST
        "tclap/*.h"
        "tclap/*.cpp"
)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/lcdapi/include)
link_directories(${PROJECT_SOURCE_DIR}/../lcdapi/.libs)
add_executable(${PROJECT_NAME} ${SRC_LIST} ${JSONRPCCPP_LIST} ${JSONCPP_LIST} ${LCDAPI_LIST} ${TCLAP_LIST})
target_link_libraries (${PROJECT_NAME} lcdapi curl icuuc libev)
add_definitions(-flto -fuse-linker-plugin -pipe)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 11)
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD_REQUIRED ON)

#################################################################################
# Clean
SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "ApplicationInfo.h;BuildInfo.h")
