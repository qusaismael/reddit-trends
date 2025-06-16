#!/bin/bash

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}================================${NC}"
    echo -e "${BLUE}  Reddit Trends - Troubleshoot${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

print_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

check_command() {
    local cmd=$1
    local name=$2
    local install_hint=$3
    
    print_check "Checking for $name..."
    if command -v "$cmd" >/dev/null 2>&1; then
        local version=$($cmd --version 2>/dev/null | head -n1 || echo "unknown")
        print_pass "$name is installed: $version"
        return 0
    else
        print_fail "$name is not installed"
        if [ -n "$install_hint" ]; then
            print_info "$install_hint"
        fi
        return 1
    fi
}

check_directory() {
    local dir=$1
    local name=$2
    
    print_check "Checking for $name..."
    if [ -d "$dir" ]; then
        print_pass "$name found at $dir"
        return 0
    else
        print_fail "$name not found at $dir"
        return 1
    fi
}

check_file() {
    local file=$1
    local name=$2
    
    print_check "Checking for $name..."
    if [ -f "$file" ]; then
        print_pass "$name found"
        return 0
    else
        print_fail "$name not found"
        return 1
    fi
}

print_header

echo "Running system diagnostics for Reddit Trends extension..."
echo ""

# System checks
echo -e "${YELLOW}=== System Requirements ===${NC}"
check_command "node" "Node.js" "Install from: https://nodejs.org/ or via Homebrew: brew install node"
check_command "npm" "npm" "Usually comes with Node.js"
check_command "ray" "Raycast CLI" "Install with: npm install -g @raycast/api@latest"
check_directory "/Applications/Raycast.app" "Raycast application"

echo ""

# Project checks
echo -e "${YELLOW}=== Project Status ===${NC}"
check_file "package.json" "Project configuration"
check_file "install.sh" "Install script"

if [ -f "package.json" ]; then
    print_check "Checking project dependencies..."
    if [ -d "node_modules" ]; then
        print_pass "Dependencies are installed"
    else
        print_fail "Dependencies not installed"
        print_info "Run: npm install"
    fi
fi

echo ""

# Build checks
echo -e "${YELLOW}=== Build Status ===${NC}"
if [ -d "dist" ]; then
    print_pass "Build output exists"
else
    print_fail "Build output not found"
    print_info "Run: npm run build"
fi

echo ""

# Environment checks
echo -e "${YELLOW}=== Environment ===${NC}"
print_info "Operating System: $(uname -s)"
print_info "Architecture: $(uname -m)"
print_info "Shell: $SHELL"
print_info "Current PATH: $PATH"

if command -v node >/dev/null 2>&1; then
    print_info "Node.js version: $(node --version)"
fi

if command -v npm >/dev/null 2>&1; then
    print_info "npm version: $(npm --version)"
    print_info "npm global prefix: $(npm config get prefix)"
fi

echo ""

# Common issues and solutions
echo -e "${YELLOW}=== Common Solutions ===${NC}"
echo "If you're experiencing issues, try these steps:"
echo ""
echo "1. Permission issues with npm:"
echo "   npm config set prefix ~/.npm-global"
echo "   export PATH=~/.npm-global/bin:\$PATH"
echo ""
echo "2. Raycast CLI not found after installation:"
echo "   export PATH=\"\$HOME/.npm-global/bin:/usr/local/bin:/opt/homebrew/bin:\$PATH\""
echo "   hash -r"
echo ""
echo "3. Extension not appearing in Raycast:"
echo "   - Make sure Raycast is running"
echo "   - Try running 'ray develop' again"
echo "   - Restart Raycast application"
echo ""
echo "4. Build errors:"
echo "   - Delete node_modules: rm -rf node_modules"
echo "   - Reinstall dependencies: npm install"
echo "   - Try building again: npm run build"
echo ""
echo "5. Still having issues?"
echo "   - Check Raycast logs in Console.app"
echo "   - Try the manual installation steps"
echo "   - Create an issue on GitHub"

echo -e "\n${GREEN}Troubleshooting complete!${NC}" 