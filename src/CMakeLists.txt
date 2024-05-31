# src/CMakeLists.txt

# Define the library
add_library(launch
    launch/myclass.cpp
)

# Define the library
add_library(patcher
    patcher/myclass.cpp
)

# Include the 'include' directory for header files
target_include_directories(launch PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)

# Include the 'include' directory for header files
target_include_directories(patcher PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/../include)

add_subdirectory(launch)
add_subdirectory(patcher)
add_subdirectory(zlib)
add_subdirectory(SDL2)
add_subdirectory(kayyte)
add_subdirectory(libogg-1.3.3)
add_subdirectory(curl)
add_subdirectory(jpeg-8c)
