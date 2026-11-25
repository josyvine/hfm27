cmake_minimum_required(VERSION 3.22.1)

project("hfm_native")

add_library(${CMAKE_PROJECT_NAME} SHARED
        native-lib.cpp)

target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
        -fvisibility=hidden
        -ffunction-sections
        -fdata-sections
        -O3
)

target_link_options(${CMAKE_PROJECT_NAME} PRIVATE
        -Wl,--gc-sections
        $<$<CONFIG:Release>:-s>
        "-Wl,-z,max-page-size=16384"
        "-Wl,-z,common-page-size=16384"
)

set_property(TARGET ${CMAKE_PROJECT_NAME} PROPERTY LINK_FLAGS "-Wl,-z,max-page-size=16384")

find_library(log-lib log)

target_link_libraries(${CMAKE_PROJECT_NAME}
        android
        ${log-lib})