#!/bin/bash
set -euo pipefail

# Change to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Variables
SUBMODULE_DIR="public"
SOURCE_PATH="/Users/raoulaime/Documents/blog/posts/"
DESTINATION_PATH="/Users/raoulaime/blogmd/blog/content/"
MY_REPO="git@github.com:raoulaime/blog.git"
COMMIT_MESSAGE="Blog update on $(date +'%Y-%m-%d %H:%M:%S')"

# Function to check if required commands are available
check_dependencies() {
    for cmd in git rsync python3 hugo; do
        if ! command -v $cmd &>/dev/null; then
            echo -e "${RED}$cmd is not installed or not in PATH.${NC}"
            exit 1
        fi
    done
}

# Function to initialize the repository if not already initialized
initialize_repo() {
    if [ ! -d ".git" ]; then
        echo -e "${GREEN}Initializing Git repository...${NC}"
        git init
        git remote add origin "$MY_REPO"
    else
        echo -e "${GREEN}Git repository already initialized.${NC}"
    fi

    if ! git remote | grep -q 'origin'; then
        echo -e "${GREEN}Adding remote origin...${NC}"
        git remote add origin "$MY_REPO"
    fi
}

# Function to sync posts using rsync
sync_posts() {
    echo -e "${GREEN}Syncing posts from Obsidian...${NC}"
    if [ ! -d "$SOURCE_PATH" ]; then
        echo -e "${RED}Source path does not exist: $SOURCE_PATH${NC}"
        exit 1
    fi

    if [ ! -d "$DESTINATION_PATH" ]; then
        echo -e "${RED}Destination path does not exist: $DESTINATION_PATH${NC}"
        exit 1
    fi

    rsync -av --delete "$SOURCE_PATH" "$DESTINATION_PATH"
}

# Function to process Markdown files
process_markdown() {
    echo -e "${GREEN}Processing Markdown files with images.py...${NC}"
    if [ ! -f "images.py" ]; then
        echo -e "${RED}Python script images.py not found.${NC}"
        exit 1
    fi

    python3 images.py
}

# Function to build the Hugo site
build_site() {
    echo -e "${GREEN}Building the Hugo site...${NC}"
    hugo
}

# Function to commit and push changes in the submodule
push_submodule() {
    echo -e "${GREEN}Pushing changes to the submodule...${NC}"
    if [ ! -d "$SUBMODULE_DIR" ]; then
        echo -e "${RED}Error: Submodule directory '$SUBMODULE_DIR' not found.${NC}"
        exit 1
    fi

    cd "$SUBMODULE_DIR"
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        git commit -m "Update submodule content"
        git push origin main
        echo -e "${GREEN}Submodule changes pushed successfully.${NC}"
    else
        echo -e "${YELLOW}No changes to push in the submodule.${NC}"
    fi
    cd ..
}

# Function to commit and push changes in the main repository
push_main_repo() {
    echo -e "${GREEN}Committing and pushing changes to the main repository...${NC}"
    git add .
    if [ -n "$(git status --porcelain)" ]; then
        git commit -m "$COMMIT_MESSAGE"
        git push origin main
        echo -e "${GREEN}Main repository changes pushed successfully.${NC}"
    else
        echo -e "${YELLOW}No changes to push in the main repository.${NC}"
    fi
}

# Main script execution
check_dependencies
initialize_repo
sync_posts
process_markdown
build_site
push_submodule
push_main_repo

echo -e "${GREEN}All done! Blog updated, built, and deployed.${NC}"
