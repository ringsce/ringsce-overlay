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

# Find Qt6 or Qt5 packages with required components
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Widgets Core Network Xml)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Widgets Core Network Xml)

# Define project sources
set(PROJECT_SOURCES
    interpreter.cpp
    interpreter.h
    main.cpp  # Include main.cpp for the example executable
    bytecode_extensions.h  # Include bytecode_extensions.h for bytecode support
    Doxyfile.in
)

# Generate object files from bytecode
add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects
    COMMAND your_bytecode_compiler ${CMAKE_CURRENT_SOURCE_DIR}/bytecode_file.bytecode -o ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects
)

# Add object files to library
add_library(kayte STATIC ${PROJECT_SOURCES} ${CMAKE_CURRENT_BINARY_DIR}/bytecode_objects)

# Set include directories if needed
target_include_directories(kayte PUBLIC include)

# Find and include the curl library
find_package(CURL REQUIRED)
target_include_directories(kayte PUBLIC ${CURL_INCLUDE_DIRS})
target_link_libraries(kayte PUBLIC ${CURL_LIBRARIES})

# Usage example
add_executable(kayte main.cpp)
target_link_libraries(kayte PRIVATE kayte)

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
add_library(Kaytana STATIC ${PROJECT_SOURCES}
    bytecode_extensions.h)

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
