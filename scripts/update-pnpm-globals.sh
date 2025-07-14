#!/bin/bash

# AWD Maestro - Global PNPM Package Updater
# Updates all globally installed PNPM packages

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "GLOBAL PNPM PACKAGE UPDATER"
echo

# Check if PNPM is installed
if ! command -v pnpm &> /dev/null; then
  print_error "PNPM is not installed. Please install PNPM first."
  exit 1
fi

# Get list of global packages
print_step "Getting list of global PNPM packages..."
global_packages=$(pnpm list -g --parseable --depth=0 2>/dev/null | grep -v "pnpm" | grep "node_modules/" | sed 's/.*node_modules\///')

if [ -z "$global_packages" ]; then
  print_info "No global PNPM packages found (excluding PNPM itself)"
  exit 0
fi

# Count global packages
package_count=$(echo "$global_packages" | wc -l)
print_info "Found ${BOLD}${package_count}${RESET} global PNPM packages"
echo

# List global packages
print_step "Global PNPM packages:"
pnpm list -g --depth=0

echo
print_step "Updating all global PNPM packages..."

# Update all global packages
pnpm update -g

if [ $? -eq 0 ]; then
  print_success "Successfully updated all global PNPM packages"
else
  print_error "Failed to update some global PNPM packages"
fi

# Show updated packages
echo
print_step "Current global PNPM packages:"
pnpm list -g --depth=0 