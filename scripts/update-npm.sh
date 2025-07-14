#!/bin/bash

# AWD Maestro - NPM Updater
# Updates NPM to the latest version

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NPM UPDATER"
echo

# Check if NPM is installed
if ! command -v npm &> /dev/null; then
  print_error "NPM is not installed. Please install Node.js first."
  exit 1
fi

# Get current NPM version
current_version=$(npm -v 2>/dev/null)
if [ -z "$current_version" ]; then
  print_error "Failed to determine current NPM version"
  exit 1
fi

print_info "Current NPM version: ${BOLD}${current_version}${RESET}"
echo

# Get latest NPM version
print_step "Checking for updates..."
latest_version=$(npm view npm version 2>/dev/null)

if [ -z "$latest_version" ]; then
  print_error "Failed to determine latest NPM version"
  exit 1
fi

print_info "Latest NPM version: ${BOLD}${latest_version}${RESET}"
echo

# Compare versions
if [ "$current_version" = "$latest_version" ]; then
  print_success "NPM is already up to date"
  exit 0
fi

# Update NPM
print_step "Updating NPM to ${BOLD}${latest_version}${RESET}..."
npm install -g npm@latest

if [ $? -eq 0 ]; then
  # Get new NPM version
  new_version=$(npm -v 2>/dev/null)
  print_success "NPM updated successfully from ${BOLD}${current_version}${RESET} to ${BOLD}${new_version}${RESET}"
else
  print_error "Failed to update NPM"
fi 