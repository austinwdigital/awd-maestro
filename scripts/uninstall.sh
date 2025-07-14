#!/bin/bash

# AWDHAUS Maestro - Uninstaller

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "AWDHAUS MAESTRO UNINSTALLER"

print_warning "This will remove AWDHAUS Maestro from your system."
print_warning "Your node/npm/pnpm installations will remain intact."
read -p "Continue? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  print_info "Uninstall cancelled"
  exit 0
fi

print_step "Removing alias from shell config"
if [ -f "$HOME/.zshrc" ]; then
  sed -i '' '/alias awdhaus-maestro=/d' "$HOME/.zshrc"
  print_success "Alias removed from .zshrc"
else
  print_info "No .zshrc file found"
fi

if [ -f "$HOME/.bashrc" ]; then
  sed -i '' '/alias awdhaus-maestro=/d' "$HOME/.bashrc"
  print_success "Alias removed from .bashrc"
fi

print_step "Removing npm global package"
if npm list -g @awdhaus/maestro &>/dev/null; then
  npm uninstall -g @awdhaus/maestro
  print_success "Package uninstalled from npm"
else
  print_info "Package not found in npm globals"
fi

print_success "AWDHAUS Maestro has been uninstalled"
print_info "You may need to restart your terminal for changes to take effect"
