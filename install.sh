#!/bin/bash

set -e

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}  Reddit Trends - Raycast Setup${NC}"
    echo -e "${BLUE}================================${NC}\n"
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

wait_for_command() {
    local cmd=$1
    local name=$2
    print_info "Waiting for $name to be available..."
    for i in {1..30}; do
        if command -v "$cmd" >/dev/null 2>&1; then
            print_success "$name is now available."
            return 0
        fi
        sleep 2
    done
    print_error "Timed out waiting for $name to be installed."
    exit 1
}

check_raycast() {
    if [ ! -d "/Applications/Raycast.app" ]; then
        print_error "Raycast is not installed."
        print_info "Please install Raycast from: https://raycast.com"
        read -p "Press Enter after installing Raycast..."
        
        if [ ! -d "/Applications/Raycast.app" ]; then
            print_error "Raycast still not found. Please install it and try again."
            exit 1
        fi
    fi
    print_success "Raycast is installed."
}

install_node() {
    if command -v npm >/dev/null 2>&1; then
        print_success "Node.js/npm is already installed."
        return 0
    fi

    print_warning "Node.js/npm is not installed."
    
    if command -v brew >/dev/null 2>&1; then
        print_info "Homebrew detected."
        read -p "Install Node.js via Homebrew? (recommended) [y/N]: " use_brew
        if [[ "$use_brew" =~ ^[Yy]$ ]]; then
            print_step "Installing Node.js via Homebrew..."
            brew install node
            wait_for_command "npm" "npm"
            return 0
        fi
    fi

    print_info "Opening Node.js download page..."
    open "https://nodejs.org/"
    read -p "Press Enter after installing Node.js..."
    
    # Reload shell environment
    export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
    hash -r 2>/dev/null || true
    
    wait_for_command "npm" "npm"
}

install_raycast_cli() {
    if command -v ray >/dev/null 2>&1; then
        print_success "Raycast CLI is already installed."
        return 0
    fi

    print_step "Installing Raycast CLI..."
    npm install -g @raycast/api@latest
    
    # Add common npm global bin paths to PATH
    export PATH="$HOME/.npm-global/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
    hash -r 2>/dev/null || true
    
    wait_for_command "ray" "Raycast CLI"
}

# Main installation process
print_header

print_step "Checking prerequisites..."

# Check for Raycast
check_raycast

# Install Node.js/npm if needed
install_node

# Install Raycast CLI if needed
install_raycast_cli

# Install project dependencies
print_step "Installing project dependencies..."
npm install

# Build the extension
print_step "Building the extension..."
npm run build

# Import extension to Raycast
print_step "Importing extension to Raycast..."
if command -v ray >/dev/null 2>&1; then
    ray develop
    print_info "Extension has been imported to Raycast in development mode."
    print_info "You can now find 'Reddit Trends' in Raycast!"
else
    print_warning "Could not automatically import to Raycast."
    print_info "Please run 'ray develop' manually in the project directory."
fi

print_success "Installation completed successfully!"
echo -e "\n${GREEN}🎉 Reddit Trends extension is ready to use!${NC}"
echo -e "\n${BLUE}Next steps:${NC}"
echo -e "1. Open Raycast (⌘ + Space)"
echo -e "2. Type 'Reddit Trends' to start browsing"
echo -e "3. Configure preferences if needed (Extensions → Reddit Trends → Preferences)"
echo -e "\n${BLUE}Useful commands:${NC}"
echo -e "• ${YELLOW}npm run dev${NC} - Start development mode"
echo -e "• ${YELLOW}npm run build${NC} - Build the extension"
echo -e "• ${YELLOW}ray develop${NC} - Re-import to Raycast" 