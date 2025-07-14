#!/bin/bash

# AWD Maestro - Uninstaller

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "AWD MAESTRO UNINSTALLER"

print_warning "This will remove AWD Maestro from your system."
print_warning "Your node/npm/pnpm installations will remain intact."
read -p "Continue? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  print_info "Uninstall cancelled"
  exit 0
fi

print_step "Removing alias from shell config"
if [ -f "$HOME/.zshrc" ]; then
  sed -i '' '/alias awd-maestro=/d' "$HOME/.zshrc"
  print_success "Alias removed from .zshrc"
else
  print_info "No .zshrc file found"
fi

if [ -f "$HOME/.bashrc" ]; then
  sed -i '' '/alias awd-maestro=/d' "$HOME/.bashrc"
  print_success "Alias removed from .bashrc"
fi

print_step "Removing npm global package"
if npm list -g @awd/maestro &>/dev/null; then
  npm uninstall -g @awd/maestro
  print_success "Package uninstalled from npm"
else
  print_info "Package not found in npm globals"
fi

print_success "AWD Maestro has been uninstalled"
print_info "You may need to restart your terminal for changes to take effect"
