#!/bin/bash

# AWDHAUS Maestro - npm-check-updates Installer
# Installs or updates the npm-check-updates package

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NPM-CHECK-UPDATES INSTALLER"
echo

# Check if NPM is installed
if ! command -v npm &> /dev/null; then
  print_error "NPM is not installed. Please install Node.js first."
  exit 1
fi

# Check if npm-check-updates is already installed
if command -v ncu &> /dev/null; then
  current_version=$(ncu --version 2>/dev/null)
  print_info "npm-check-updates is already installed (version ${BOLD}${current_version}${RESET})"
  
  # Check for updates
  print_step "Checking for updates..."
  latest_version=$(npm view npm-check-updates version 2>/dev/null)
  
  if [ -z "$latest_version" ]; then
    print_error "Failed to determine latest version"
    exit 1
  fi
  
  print_info "Latest version: ${BOLD}${latest_version}${RESET}"
  
  # Compare versions (simple string comparison, not semantic)
  if [ "$current_version" = "$latest_version" ]; then
    print_success "npm-check-updates is already up to date"
    exit 0
  fi
  
  # Update npm-check-updates
  print_step "Updating npm-check-updates to version ${BOLD}${latest_version}${RESET}..."
else
  print_step "Installing npm-check-updates..."
fi

# Install/update npm-check-updates
npm install -g npm-check-updates

if [ $? -eq 0 ]; then
  new_version=$(ncu --version 2>/dev/null)
  print_success "npm-check-updates ${BOLD}${new_version}${RESET} installed successfully"
  
  # Show usage instructions
  echo
  print_section "USAGE INSTRUCTIONS"
  echo -e "${TERTIARY}To check for outdated dependencies in a project:${RESET}"
  echo -e "  ${GRAY}cd /path/to/project${RESET}"
  echo -e "  ${GRAY}ncu${RESET}"
  echo
  echo -e "${TERTIARY}To update all dependencies in package.json:${RESET}"
  echo -e "  ${GRAY}ncu -u${RESET}"
  echo
  echo -e "${TERTIARY}To update specific packages:${RESET}"
  echo -e "  ${GRAY}ncu -u package1 package2${RESET}"
  echo
else
  print_error "Failed to install npm-check-updates"
fi 