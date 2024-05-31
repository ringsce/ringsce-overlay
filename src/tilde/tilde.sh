#!/bin/bash

# Define the scripts to run
CHECK_GIT_SCRIPT="check_git.sh"
DOWNLOAD_SCRIPT="download_from_github.sh"

# Function to ensure the required scripts are executable
ensure_executable() {
    chmod +x $CHECK_GIT_SCRIPT
    chmod +x $DOWNLOAD_SCRIPT
}

# Ensure the scripts are executable
ensure_executable

# Run the git check script
./$CHECK_GIT_SCRIPT
if [ $? -ne 0 ]; then
    echo "Git check failed. Exiting."
    exit 1
fi

# Ensure a GitHub URL is provided
GITHUB_URL="$1"
if [ -z "$GITHUB_URL" ]; then
    echo "Usage: $0 <github-url>"
    exit 1
fi

# Run the download script with the provided GitHub URL
./$DOWNLOAD_SCRIPT "$GITHUB_URL"
if [ $? -ne 0 ]; then
    echo "Download failed. Exiting."
    exit 1
fi

echo "Scripts completed successfully."
