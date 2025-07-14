#!/bin/bash

# AWDHAUS Maestro - PNPM Cleanup

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "PNPM CLEANUP"

if ! command -v pnpm &>/dev/null; then
  print_error "PNPM is not installed"
  exit 1
fi

print_step "Updating global packages"
pnpm update -g

print_step "Pruning global store"
pnpm store prune

print_step "Clearing PNPM cache"
if [ -d "$HOME/.cache/pnpm" ]; then
  rm -rf "$HOME/.cache/pnpm"
  print_success "PNPM cache cleared"
else
  print_info "No PNPM cache found"
fi

print_success "Your PNPM environment is clean and current"
