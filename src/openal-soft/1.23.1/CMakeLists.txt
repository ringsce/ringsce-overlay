cmake_minimum_required(VERSION 3.10)
project(MyOpenAL)

# Find OpenAL
find_package(OpenAL REQUIRED)

# Add your source files
#set(SOURCE_FILES
#    src/main.cpp
#    src/audio.cpp
#    src/utils.cpp
#)

# Add your header files
set(HEADER_FILES
    include/AL/al.h
    include/AL/alc.h
    include/AL/alext.h
    include/AL/efx-creative.h
    include/AL/efx-presets.h
    include/AL/efx.h
)

# Add executable target
add_executable(MyOpenAL ${SOURCE_FILES} ${HEADER_FILES})

# Include header directories
target_include_directories(MyOpenAL PRIVATE include)

# Link OpenAL
target_link_libraries(MyOpenAL PRIVATE OpenAL::OpenAL)
