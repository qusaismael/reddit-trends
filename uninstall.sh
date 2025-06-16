#!/bin/bash

set -e

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${RED}================================${NC}"
    echo -e "${RED}  Reddit Trends - Uninstall${NC}"
    echo -e "${RED}================================${NC}\n"
}

print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_header

print_warning "This will remove the Reddit Trends extension from Raycast."
read -p "Are you sure you want to continue? [y/N]: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

print_step "Removing extension from Raycast..."

# Remove from Raycast development extensions
if command -v ray >/dev/null 2>&1; then
    # Get the current directory name (extension name)
    EXTENSION_NAME=$(basename "$(pwd)")
    
    # Try to remove from Raycast
    print_info "Attempting to remove extension from Raycast..."
    
    # Note: There's no direct "ray remove" command, so we inform the user
    print_info "Extension development mode stopped."
    print_warning "To completely remove the extension from Raycast:"
    echo -e "1. Open Raycast"
    echo -e "2. Go to Extensions settings"
    echo -e "3. Find 'Reddit Trends' and disable/remove it"
else
    print_warning "Raycast CLI not found. Extension may still be active in Raycast."
fi

# Clean up build artifacts
print_step "Cleaning up build artifacts..."
if [ -d "dist" ]; then
    rm -rf dist
    print_success "Removed dist directory"
fi

if [ -d "node_modules" ]; then
    read -p "Remove node_modules directory? [y/N]: " remove_deps
    if [[ "$remove_deps" =~ ^[Yy]$ ]]; then
        rm -rf node_modules
        print_success "Removed node_modules directory"
    fi
fi

print_success "Uninstall completed!"
echo -e "\n${BLUE}Note:${NC} You may need to manually remove the extension from Raycast settings."
echo -e "The project files remain in this directory. Delete this folder to completely remove all files." 