#!/bin/bash

# Function to download a repository from a GitHub URL
download_github_repo() {
    local repo_url=$1
    local target_dir=$2

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        echo "git is not installed. Please install git to use this function."
        return 1
    fi

    # Check if the repository URL is provided
    if [ -z "$repo_url" ]; then
        echo "Usage: download_github_repo <repo_url> [target_dir]"
        return 1
    fi

    # Clone the repository
    if [ -z "$target_dir" ]; then
        git clone "$repo_url"
    else
        git clone "$repo_url" "$target_dir"
    fi

    if [ $? -eq 0 ]; then
        echo "Repository successfully downloaded."
    else
        echo "Failed to download the repository."
        return 1
    fi
}

# Example usage:
# download_github_repo "https://github.com/user/repo.git"
# download_github_repo "https://github.com/user/repo.git" "/path/to/target_dir"
