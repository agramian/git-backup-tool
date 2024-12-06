#!/bin/bash

# Script to backup a list of Git repositories as bundles

# Exit on error
set -e

# Check for required tools
REQUIRED_TOOLS=("git" "tar")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo "Error: $tool is not installed." >&2
        exit 1
    fi
done

# Function to display usage
usage() {
    echo "Usage: $0 <repo_list_file> <output_directory>"
    echo "  repo_list_file    Path to a file containing a list of Git repository URLs"
    echo "  output_directory  Directory to store backups (will be created if not exists)"
    exit 1
}

# Validate arguments
if [ "$#" -ne 2 ]; then
    usage
fi

REPO_LIST_FILE="$1"
OUTPUT_DIR="$2"

# Ensure the repo list file exists
if [ ! -f "$REPO_LIST_FILE" ]; then
    echo "Error: Repository list file '$REPO_LIST_FILE' not found." >&2
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Resolve absolute path for the output directory
OUTPUT_DIR="$(realpath "$OUTPUT_DIR")"

# Process each repository
while IFS= read -r REPO_URL; do
    if [ -z "$REPO_URL" ] || [[ "$REPO_URL" =~ ^# ]]; then
        continue  # Skip empty lines or lines that start with #
    fi

    REPO_NAME=$(basename -s .git "$REPO_URL")
    echo "Processing repository: $REPO_URL"

    # Clone the bare repository into a temporary directory
    TEMP_DIR=$(mktemp -d)
    cd $TEMP_DIR
    git clone --bare "$REPO_URL" "$TEMP_DIR/$REPO_NAME.git"

    # Bundle the repository
    cd "$TEMP_DIR/$REPO_NAME.git"
    git bundle create "$TEMP_DIR/$REPO_NAME.bundle" --all

    # Verify the bundle
    git bundle verify "$TEMP_DIR/$REPO_NAME.bundle"

    # Compress the bundle
    tar -czvf "$OUTPUT_DIR/$REPO_NAME.bundle.tar.gz" -C "$TEMP_DIR" "$REPO_NAME.bundle"

    # Cleanup temporary directory
    rm -rf "$TEMP_DIR"

    echo "Backup for $REPO_URL completed: $OUTPUT_DIR/$REPO_NAME.bundle.tar.gz"
done <"$REPO_LIST_FILE"

echo "All repositories have been backed up successfully."
