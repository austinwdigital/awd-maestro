#!/bin/bash

# AWD Maestro - Global NPM Package Updater
# Updates all globally installed NPM packages

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "GLOBAL NPM PACKAGE UPDATER"
echo

# Check if NPM is installed
if ! command -v npm &> /dev/null; then
  print_error "NPM is not installed. Please install Node.js first."
  exit 1
fi

# Get list of outdated global packages
print_step "Checking for outdated global NPM packages..."
outdated_packages=$(npm outdated -g --parseable 2>/dev/null)

if [ -z "$outdated_packages" ]; then
  print_success "All global NPM packages are up to date"
  exit 0
fi

# Count outdated packages
outdated_count=$(echo "$outdated_packages" | wc -l)
print_info "Found ${BOLD}${outdated_count}${RESET} outdated global NPM packages"
echo

# List outdated packages with versions
print_step "Outdated packages:"
npm outdated -g --depth=0

echo
print_step "Updating all global NPM packages..."

# Update all global packages
npm update -g

if [ $? -eq 0 ]; then
  print_success "Successfully updated all global NPM packages"
else
  print_error "Failed to update some global NPM packages"
fi

# Check if any packages are still outdated
still_outdated=$(npm outdated -g --parseable 2>/dev/null)
if [ -n "$still_outdated" ]; then
  still_outdated_count=$(echo "$still_outdated" | wc -l)
  print_warning "${BOLD}${still_outdated_count}${RESET} packages could not be updated automatically"
  echo
  print_step "Packages that need manual updating:"
  npm outdated -g --depth=0
  echo
  print_info "You may need to manually update these packages using: npm install -g package@latest"
fi 