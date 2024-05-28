cmake_minimum_required(VERSION 3.29)

project(Kayte-lang VERSION 0.1.0 LANGUAGES CXX)

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
        set(CMAKE_IOS_DEPLOYMENT_TARGET 9.0)
    else()
        set(CMAKE_SYSTEM_NAME macOS)
        set(CMAKE_OSX_ARCHITECTURES "arm64")
        set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0)
    endif()
elseif(UNIX AND NOT APPLE)
    set(CMAKE_SYSTEM_NAME Linux)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(CMAKE_SYSTEM_PROCESSOR arm64)
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

# Example target (for demonstration purposes)
add_executable(example main.cpp)

# Link directories to the target (if needed)
foreach(dir ${DIRECTORIES})
    if(DIR_${dir}_FOUND)
        target_link_libraries(example ${dir})
    endif()
endforeach()
