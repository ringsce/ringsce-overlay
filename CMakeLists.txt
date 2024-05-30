cmake_minimum_required(VERSION 3.29)
project(Kayte-lang VERSION 0.1.0 LANGUAGES CXX D) # Added D language

# Enable automatic Qt features
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Require C++17 standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set minimum required versions for different platforms
if(ANDROID)
    set(CMAKE_SYSTEM_NAME Android)
    set(CMAKE_SYSTEM_VERSION 21) # Minimum API level
elseif(APPLE)
    if(IOS)
        set(CMAKE_SYSTEM_NAME iOS)
        set(CMAKE_OSX_ARCHITECTURES "arm64")
        set(CMAKE_IOS_DEPLOYMENT_TARGET 15.0)
    else()
        set(CMAKE_SYSTEM_NAME macOS)
        set(CMAKE_OSX_ARCHITECTURES "arm64")
        set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0)
    endif()
elseif(UNIX AND NOT APPLE)
    set(CMAKE_SYSTEM_NAME Linux)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(CMAKE_SYSTEM_PROCESSOR arm64)
        message(STATUS "Configuring for Linux on aarch64")
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "armv7l")
        message(STATUS "Configuring for Raspberry Pi 3+")
        # Add Raspberry Pi specific options and flags here if needed
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard")
    endif()
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

# Define the directories to check
set(DIRECTORIES
    "dir1"
    "dir2"
    "dir3"
    "dir4"
    "dir5"
    "dir6"
    "dir7"
    "dir8"
    "dir9"
)

# Function to check if a directory exists
function(check_directory dir)
    if(IS_DIRECTORY ${dir})
        message(STATUS "Directory found: ${dir}")
        set(DIR_${dir}_FOUND ON PARENT_SCOPE)
    else()
        message(STATUS "Directory not found: ${dir}")
        set(DIR_${dir}_FOUND OFF PARENT_SCOPE)
    endif()
endfunction()

# Check each directory
foreach(dir ${DIRECTORIES})
    check_directory(${dir})
endforeach()

# Output results
foreach(dir ${DIRECTORIES})
    if(DIR_${dir}_FOUND)
        message(STATUS "${dir} is present.")
    else()
        message(STATUS "${dir} is not present.")
    endif()
endforeach()

# Include directories in the project (if needed)
foreach(dir ${DIRECTORIES})
    if(DIR_${dir}_FOUND)
        include_directories(${dir})
    endif()
endforeach()

# Add curl library
find_package(CURL REQUIRED)
include_directories(${CURL_INCLUDE_DIRS})
target_link_libraries(kayte PUBLIC ${CURL_LIBRARIES})

# Configure Emscripten
if(EMSCRIPTEN)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s WASM=1")
    set(CMAKE_EXECUTABLE_SUFFIX ".html")
endif()

# Define project sources for C++ and D
set(PROJECT_SOURCES_CPP
    interpreter.cpp
    interpreter.h
    main.cpp  # Include main.cpp for the example executable
    bytecode_extensions.h  # Include bytecode_extensions.h for bytecode support
)

set(PROJECT_SOURCES_D
    example.d  # Add your D source files here
)

# Add libraries and executables for C++
add_library(kayte STATIC ${PROJECT_SOURCES_CPP} ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects)
target_include_directories(kayte PUBLIC include)
add_executable(kayte_executable main.cpp)
target_link_libraries(kayte_executable PRIVATE kayte)

# Add libraries and executables for D
add_library(kayte_d STATIC ${PROJECT_SOURCES_D})
add_executable(kayte_d_executable example.d)
target_link_libraries(kayte_d_executable PRIVATE kayte_d)

# Link Qt libraries to the Kaytana library
target_link_libraries(kayte PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Xml)
target_link_libraries(kayte_executable PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Xml)

# Configure Doxyfile for documentation generation
set(DOXYGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/doxygen)
configure_file(Doxyfile.in ${CMAKE_BINARY_DIR}/Doxyfile @ONLY)

# Add a custom target to run Doxygen for generating documentation
find_package(Doxygen)
if(Doxygen_FOUND)
    add_custom_target(docs
        COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/Doxyfile
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM
    )
endif()
