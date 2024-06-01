cmake_minimum_required(VERSION 3.29)
project(tilde)

# Add executable for each bash file
add_executable(git git.sh)
add_executable(run run.sh)
add_executable(tilde tilde.sh)

# Optionally, if you want to install these scripts
install(TARGETS git run tilde
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
