cmake_minimum_required(VERSION 3.29)
project(Kayte-lang VERSION 0.1.0 LANGUAGES CXX D)

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
    endif()
elseif(WIN32)
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
        set(CMAKE_SYSTEM_NAME Windows)
    else()
        message(FATAL_ERROR "Unsupported processor for Windows platform")
    endif()
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

# Find and set the LLVM-based D compiler (LDC)
find_program(CMAKE_D_COMPILER NAMES ldc2)
if(NOT CMAKE_D_COMPILER)
    message(FATAL_ERROR "No LLVM-based D compiler (LDC) found. Please install LDC.")
else()
    set(CMAKE_D_COMPILER ${CMAKE_D_COMPILER} CACHE STRING "The LLVM-based D compiler")
    message(STATUS "LLVM-based D compiler found: ${CMAKE_D_COMPILER}")
endif()

# Set LLVM toolchain settings
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -lc++abi")
endif()

# Define the directories to check
set(DIRECTORIES
    "src/kayte"
    "src/jpeg-8c"
    "src/curl-7.54.0"
    "src/libogg-1.3.3"
    "src/openal-soft"
    "src/patcher"
    "src/sdl"
    "src/SDL2"
    "src/zlib"
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

# Define project sources
set(PROJECT_SOURCES
    interpreter.cpp
    interpreter.h
    main.cpp  # Include main.cpp for the example executable
    bytecode_extensions.h  # Include bytecode_extensions.h for bytecode support
    Doxyfile.in
    ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects  # Add bytecode object files
)

# Add DLang sources
set(DLANG_SOURCES
    src/kayte.d
)

# Add DLang sources to the project
add_library(kayte STATIC ${PROJECT_SOURCES} ${DLANG_SOURCES})

# Set include directories if needed
target_include_directories(kayte PUBLIC include)

# Example target (for demonstration purposes)
add_executable(kayte_exe main.cpp)
target_link_libraries(kayte_exe PRIVATE kayte)

# Configure settings for different platforms
if(ANDROID)
    message(STATUS "Configuring for Android")
    set(PLATFORM_SPECIFIC_SOURCES
        # Add any Android-specific sources here
    )
elseif(WIN32 AND CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    message(STATUS "Configuring for Windows 11 ARM")
    set(PLATFORM_SPECIFIC_SOURCES
        # Add any Windows 11 ARM-specific sources here
    )
elseif(UNIX AND CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    message(STATUS "Configuring for Linux ARM")
    set(PLATFORM_SPECIFIC_SOURCES
        # Add any Linux ARM-specific sources here
    )
else()
    message(WARNING "Platform not explicitly supported. Default configuration applied.")
endif()

# Include the platform-specific sources in the build
if(PLATFORM_SPECIFIC_SOURCES)
    list(APPEND PROJECT_SOURCES ${PLATFORM_SPECIFIC_SOURCES})
endif()

# Add the Kaytana library target
add_library(Kaytana STATIC ${PROJECT_SOURCES} bytecode_extensions.h)

# Set platform-specific properties if needed
if(ANDROID)
    # Android-specific configurations
elseif(WIN32 AND CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    # Windows 11 ARM-specific configurations
elseif(UNIX AND CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    # Linux ARM-specific configurations
endif()

# Link Qt libraries to the Kaytana library
target_link_libraries(Kaytana PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Xml)

# Add the example executable that links to the Kaytana library
add_executable(KaytanaLib main.cpp)
target_link_libraries(KaytanaLib PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Xml Kaytana)

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

# Add support for building Kayte as a DLL on Windows 11 ARM
if(WIN32 AND CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
    add_library(kayte SHARED ${PROJECT_SOURCES} ${DLANG_SOURCES})
    target_compile_definitions(kayte PRIVATE KAYTE_DLL)
    set_target_properties(kayte PROPERTIES
        WINDOWS_EXPORT_ALL_SYMBOLS ON
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
    )
endif()
