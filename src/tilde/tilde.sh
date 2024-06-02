#!/bin/bash

# Function to ensure the required scripts are executable
ensure_executable() {
    chmod +x $CHECK_GIT_SCRIPT
    chmod +x $DOWNLOAD_SCRIPT
}

# Function to generate CMakeLists.txt
generate_cmake() {
    cat <<EOL > CMakeLists.txt
cmake_minimum_required(VERSION 3.0)
project($PROJECT_NAME)

# Add executable for each bash file
add_executable(check_git check_git.sh)
add_executable(download_from_github download_from_github.sh)

# Optionally, if you want to install these scripts
install(TARGETS check_git download_from_github
        DESTINATION \${CMAKE_INSTALL_PREFIX}/bin)
EOL
    echo "CMakeLists.txt file generated successfully."
}

# Function to create __init__.py
create_init_py() {
    cat <<EOL > __init__.py
"""
Package Initialization
"""

# You can add package initialization code here
EOL
    echo "__init__.py file created successfully."
}

# Function to download from GitHub
download_from_github() {
    GITHUB_URL="$1"
    TARGET_DIR="${2:-$(basename "$GITHUB_URL" .git)}"

    if [ -d "$TARGET_DIR" ]; then
        echo "Directory $TARGET_DIR already exists. Pulling the latest changes."
        cd "$TARGET_DIR"
        git pull origin main || { echo "Failed to pull latest changes."; exit 1; }
        cd ..
    else
        echo "Cloning $GITHUB_URL into $TARGET_DIR."
        git clone "$GITHUB_URL" "$TARGET_DIR" || { echo "Failed to clone repository."; exit 1; }
    fi
    echo "Repository downloaded successfully."
}

# Parse arguments
while getopts "p:r:c:" opt; do
    case $opt in
        p) PROJECT_NAME="$OPTARG"
