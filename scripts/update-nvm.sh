#!/bin/bash

# AWD Maestro - NVM Updater
# Updates Node Version Manager to the latest version

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NVM UPDATER"
echo

# Check if NVM is installed
if [ ! -d "$HOME/.nvm" ]; then
  print_error "NVM is not installed. Installing now..."
  curl -o- --tlsv1.2 --connect-timeout 10 --max-time 60 https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  
  if [ $? -eq 0 ]; then
    print_success "NVM installed successfully"
  else
    print_error "Failed to install NVM"
    exit 1
  fi
else
  print_success "NVM is already installed"
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Get current NVM version
current_version=$(nvm --version 2>/dev/null)
if [ -z "$current_version" ]; then
  print_error "Failed to determine current NVM version"
  exit 1
fi

print_info "Current NVM version: ${BOLD}${current_version}${RESET}"
echo

# Get latest NVM version
print_step "Checking for updates..."
nvm_latest=$(curl -s --tlsv1.2 --connect-timeout 10 --max-time 30 https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$nvm_latest" ]; then
  print_error "Failed to determine latest NVM version"
  exit 1
fi

print_info "Latest NVM version: ${BOLD}${nvm_latest}${RESET}"
echo

# Compare versions
if [ "$nvm_latest" = "v$current_version" ]; then
  print_success "NVM is already up to date"
  exit 0
fi

# Update NVM
print_step "Updating NVM to ${BOLD}${nvm_latest}${RESET}..."
curl -o- --tlsv1.2 --connect-timeout 10 --max-time 60 "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_latest}/install.sh" | bash

if [ $? -eq 0 ]; then
  print_success "NVM updated successfully to ${BOLD}${nvm_latest}${RESET}"
  
  # Reload NVM
  print_step "Reloading NVM..."
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  # Verify update
  new_version=$(nvm --version 2>/dev/null)
  print_info "New NVM version: ${BOLD}${new_version}${RESET}"
else
  print_error "Failed to update NVM"
fi 