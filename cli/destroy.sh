#!/bin/bash

# Save the initial working directory
INITIAL_DIR=$(pwd)

# Get the absolute path of the directory containing the script
SCRIPT_ABSPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get the source directory
SRC_DIR="$SCRIPT_ABSPATH"/../src

# Stop and remove docker containers, images, and volumes
docker-compose down --rmi all --volumes

# Function to remove a directory if it exists
remove_dir_if_exists() {
    target_dir="$SRC_DIR/$1"
    if [ -d "$target_dir" ]; then
        echo "Removing directory: $target_dir"
        rm -rf "$target_dir"
    else
        echo "Directory not found: $target_dir"
    fi
}

# Remove the 'vendor' and 'web/wp' directories if they exist
remove_dir_if_exists "vendor"
remove_dir_if_exists "web/wp"

# Return to the initial working directory
cd "$INITIAL_DIR"