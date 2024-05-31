cmake_minimum_required(VERSION 3.10)
project(MyOpenALProject)

# Find OpenAL
find_package(OpenAL REQUIRED)

# Add your source files
set(SOURCE_FILES
    src/main.cpp
    src/audio.cpp
    src/utils.cpp
)

# Add your header files
set(HEADER_FILES
    include/audio.h
    include/utils.h
)

# Add executable target
add_executable(MyOpenALExecutable ${SOURCE_FILES} ${HEADER_FILES})

# Include header directories
target_include_directories(MyOpenALExecutable PRIVATE include)

# Link OpenAL
target_link_libraries(MyOpenALExecutable PRIVATE OpenAL::OpenAL)
