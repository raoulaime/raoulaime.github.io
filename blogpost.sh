#!/bin/bash
set -euo pipefail

# Change to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Main repository and submodule directories
SUBMODULE_DIR="public"


# Set variables for Obsidian to Hugo copy
sourcePath="/Users/raoulaime/Documents/blog/posts/"
destinationPath="/Users/raoulaime/blogmd/blog/content/"

# Set GitHub Repo
myrepo="git@github.com:raoulaime/blog.git"

# Check for required commands
for cmd in git rsync python3 hugo; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd is not installed or not in PATH."
        exit 1
    fi
done

# Step 1: Check if Git is initialized, and initialize if necessary
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    git remote add origin $myrepo
else
    echo "Git repository already initialized."
    if ! git remote | grep -q 'origin'; then
        echo "Adding remote origin..."
        git remote add origin $myrepo
    fi
fi

# Step 2: Sync posts from Obsidian to Hugo content folder using rsync
echo "Syncing posts from Obsidian..."

if [ ! -d "$sourcePath" ]; then
    echo "Source path does not exist: $sourcePath"
    exit 1
fi

if [ ! -d "$destinationPath" ]; then
    echo "Destination path does not exist: $destinationPath"
    exit 1
fi

rsync -av --delete "$sourcePath" "$destinationPath"

# Step 3: Process Markdown files with Python script to handle image links
echo "Processing image links in Markdown files..."
if [ ! -f "images.py" ]; then
    echo "Python script images.py not found."
    exit 1
fi

if ! python3 images.py; then
    echo "Failed to process image links."
    exit 1
fi

# Step 4: Build the Hugo site
echo "Building the Hugo site..."
if ! hugo; then
    echo "Hugo build failed."
    exit 1
fi

# Step 5: Add changes to Git
echo "Staging changes for Git..."
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to stage."
else
    git add .
fi

# Step 6: Commit changes with a dynamic message
commit_message="New Blog Post on $(date +'%Y-%m-%d %H:%M:%S')"
if git diff --cached --quiet; then
    echo "No changes to commit."
else
    echo "Committing changes..."
    git commit -m "$commit_message"
fi

# Step 7: Push all changes to the main branch
echo "Deploying to GitHub Main..."
if ! git push origin main; then
    echo "Failed to push to main branch."
    exit 1
fi

# Function to push changes in the submodule
push_submodule() {
    echo -e "${GREEN}Pushing changes to the submodule...${NC}"
    cd "$SUBMODULE_DIR"

    # Check for changes in the submodule
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        git commit -m "Update submodule content"
        git push origin main
        echo -e "${GREEN}Submodule changes pushed successfully.${NC}"
    else
        echo -e "${GREEN}No changes to push in the submodule.${NC}"
    fi

    # Go back to the main repository
    cd ..
}

# Function to push changes in the main repository
push_main_repo() {
    echo -e "${GREEN}Pushing changes to the main repository...${NC}"
    git add .
    git commit -m "Update main repository"
    git push origin main
    echo -e "${GREEN}Main repository changes pushed successfully.${NC}"
}

# Ensure the script is run from the main repository
if [ ! -d "$SUBMODULE_DIR" ]; then
    echo -e "${RED}Error: Submodule directory '$SUBMODULE_DIR' not found!${NC}"
    exit 1
fi

# Push changes in the submodule first, then the main repository
push_submodule
push_main_repo

echo "All done! Site synced, processed, committed, built, and deployed."
