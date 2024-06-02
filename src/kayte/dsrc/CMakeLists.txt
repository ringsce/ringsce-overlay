cmake_minimum_required(VERSION 3.10)
project(kayteC LANGUAGES D)

# Set source files
set(SOURCES
    interpreter.di
    updater.d
    pk3_manager.d
    xml_reader.d
    main.d
)

# Add the executable
add_executable(interpreter ${SOURCES})
