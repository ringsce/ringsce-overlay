#!/bin/bash

# Function to check if git is installed
check_git_command() {
    if command -v git &> /dev/null; then
        echo "git is installed."
        git --version
    else
        echo "git is not installed. Please install git."
    fi
}

# Call the function to check git command
check_git_command
