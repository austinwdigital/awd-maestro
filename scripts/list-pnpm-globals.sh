#!/bin/bash

# AWD Maestro - List PNPM Global Packages

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "PNPM GLOBAL PACKAGES"

if ! command -v pnpm &>/dev/null; then
  print_error "PNPM is not installed"
  exit 1
fi

print_step "Listing globally installed PNPM packages"
pnpm list -g --depth=0
