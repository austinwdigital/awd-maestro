#!/bin/bash

# AWDHAUS Maestro - Maestro Concierge
# Comprehensive system maintenance and optimization

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_maestro_header

# Run health check first to assess the system
print_step "Running system health assessment..."
"${SCRIPT_DIR}/dev-health-check.sh" --quiet

# Update NVM
print_step "Updating Node Version Manager..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm_latest=$(curl -s --tlsv1.2 --connect-timeout 10 --max-time 30 https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -n "$nvm_latest" ]; then
  curl -o- --tlsv1.2 --connect-timeout 10 --max-time 60 https://raw.githubusercontent.com/nvm-sh/nvm/$nvm_latest/install.sh | bash
  print_success "NVM updated to $nvm_latest"
else
  print_warning "Could not determine latest NVM version"
fi

# Update NPM
print_step "Updating NPM to latest version..."
npm install -g npm@latest
print_success "NPM updated to $(npm -v)"

# Clean NPM cache
print_step "Cleaning NPM cache..."
npm cache clean --force
print_success "NPM cache cleaned"

# Update global NPM packages
print_step "Updating global NPM packages..."
npm update -g
print_success "Global NPM packages updated"

# Install/Update npm-check-updates
print_step "Installing/Updating npm-check-updates..."
npm install -g npm-check-updates
print_success "npm-check-updates installed/updated"

# Update PNPM if installed
if command -v pnpm &> /dev/null; then
  print_step "Updating PNPM..."
  npm install -g pnpm@latest
  print_success "PNPM updated to $(pnpm --version)"
  
  print_step "Cleaning PNPM store..."
  pnpm store prune
  print_success "PNPM store cleaned"
  
  print_step "Updating global PNPM packages..."
  pnpm update -g
  print_success "Global PNPM packages updated"
fi

# Clear NVM cache
print_step "Clearing NVM cache..."
rm -rf "$HOME/.nvm/.cache"
print_success "NVM cache cleared"

# Clean up temporary files
print_step "Cleaning up temporary files..."
rm -rf /tmp/npm-*
rm -rf /tmp/pnpm-*
print_success "Temporary files cleaned"

# Final message
echo
echo -e "${PRIMARY}${BOLD}╭── MAESTRO CONCIERGE $(printf '%0.s─' $(seq 1 47))╮${RESET}"
echo -e "${PRIMARY}${BOLD}│${RESET} ${SUCCESS}System maintenance complete!${RESET}                                ${PRIMARY}${BOLD}│${RESET}"
echo -e "${PRIMARY}${BOLD}│${RESET} ${WHITE}Your development environment has been optimized${RESET}                ${PRIMARY}${BOLD}│${RESET}"
echo -e "${PRIMARY}${BOLD}╰$(printf '%0.s─' $(seq 1 67))╯${RESET}"
echo 