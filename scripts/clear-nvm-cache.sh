#!/bin/bash

# AWD Maestro - NVM/NPM Cache Cleanup

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NVM/NPM CACHE CLEANUP"
print_step "Clearing NVM cache"

if command -v nvm &>/dev/null; then
  nvm cache clear
  print_success "NVM cache cleared"
else
  print_warning "NVM not found, skipping cache clear"
fi

print_step "Clearing NPM cache"
if command -v npm &>/dev/null; then
  npm cache clean --force
  print_success "NPM cache cleared"
else
  print_warning "NPM not found, skipping cache clear"
fi

print_success "Cache cleanup complete"
