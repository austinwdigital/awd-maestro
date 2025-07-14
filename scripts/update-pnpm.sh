#!/bin/bash

# AWDHAUS Maestro - PNPM Updater
# Updates PNPM to the latest version

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "PNPM UPDATER"
echo

# Check if NPM is installed (required to install/update PNPM)
if ! command -v npm &> /dev/null; then
  print_error "NPM is not installed. Please install Node.js first."
  exit 1
fi

# Check if PNPM is installed
if ! command -v pnpm &> /dev/null; then
  print_warning "PNPM is not installed. Installing now..."
  npm install -g pnpm
  
  if [ $? -eq 0 ]; then
    print_success "PNPM installed successfully"
  else
    print_error "Failed to install PNPM"
    exit 1
  fi
else
  print_success "PNPM is already installed"
fi

# Get current PNPM version
current_version=$(pnpm --version 2>/dev/null)
if [ -z "$current_version" ]; then
  print_error "Failed to determine current PNPM version"
  exit 1
fi

print_info "Current PNPM version: ${BOLD}${current_version}${RESET}"
echo

# Get latest PNPM version
print_step "Checking for updates..."
latest_version=$(npm view pnpm version 2>/dev/null)

if [ -z "$latest_version" ]; then
  print_error "Failed to determine latest PNPM version"
  exit 1
fi

print_info "Latest PNPM version: ${BOLD}${latest_version}${RESET}"
echo

# Compare versions
if [ "$current_version" = "$latest_version" ]; then
  print_success "PNPM is already up to date"
  exit 0
fi

# Update PNPM
print_step "Updating PNPM to ${BOLD}${latest_version}${RESET}..."
npm install -g pnpm@latest

if [ $? -eq 0 ]; then
  # Get new PNPM version
  new_version=$(pnpm --version 2>/dev/null)
  print_success "PNPM updated successfully from ${BOLD}${current_version}${RESET} to ${BOLD}${new_version}${RESET}"
else
  print_error "Failed to update PNPM"
fi 