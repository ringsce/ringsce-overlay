cmake_minimum_required(VERSION 3.10)
project(MyProject)

# Find zlib
find_package(ZLIB REQUIRED)

# Add your source files
set(SOURCE_FILES
    adler32.c
    crc32.c
    inffast.c
    inflate.c
    inftrees.c
    zutil.c
)

# Add your header files
set(HEADER_FILES
    adler32.h
    crc32.h
    inffast.h
    inffixed.h
    inflate.h
    inftrees.h
    trees.h
    zconf.h
    zlib.h
    zutil.h
)

# Add executable target
add_executable(MyExecutable ${SOURCE_FILES} ${HEADER_FILES})

# Link zlib
target_link_libraries(MyExecutable PRIVATE ZLIB::ZLIB)
