#!/bin/bash

# AWDHAUS Maestro - List NPM Global Packages

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NPM GLOBAL PACKAGES"

if ! command -v npm &>/dev/null; then
  print_error "NPM is not installed"
  exit 1
fi

print_step "Listing globally installed NPM packages"
npm list -g --depth=0
