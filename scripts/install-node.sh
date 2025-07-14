#!/bin/bash

# AWD Maestro - Node.js Version Installer
# Allows installing new Node.js versions

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NODE.JS VERSION INSTALLER"
echo

# Check if NVM is installed
if [ ! -d "$HOME/.nvm" ]; then
  print_error "NVM is not installed. Please install NVM first."
  exit 1
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Get current Node.js version
current_version=$(node -v 2>/dev/null)
if [ -z "$current_version" ]; then
  current_version="none"
fi

print_info "Current Node.js version: ${BOLD}${current_version}${RESET}"
echo

# Get installed versions
print_step "Installed Node.js versions:"
installed_versions=$(nvm ls --no-colors | grep -v "default" | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | sort -V)

# Display installed versions
echo
if [ -z "$installed_versions" ]; then
  print_warning "No Node.js versions installed via NVM"
else
  for version in $installed_versions; do
    if [[ "$version" == "$current_version" ]]; then
      echo -e "  ${SUCCESS}${BOLD}${version}${RESET} ${TERTIARY}(current)${RESET}"
    else
      echo -e "  ${GRAY}${version}${RESET}"
    fi
  done
fi
echo

# Get available versions
print_step "Fetching available Node.js versions..."
available_versions=$(nvm ls-remote --no-colors | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | grep -v "rc" | grep -v "nightly" | grep -v "next" | grep -v "test" | sort -V | tail -n 20)

# Display available versions
echo
echo -e "${TERTIARY}Available LTS and stable versions (most recent 20):${RESET}"
for version in $available_versions; do
  echo -e "  ${GRAY}${version}${RESET}"
done
echo

# Prompt for version selection
echo -e "${TERTIARY}Enter the Node.js version to install (e.g., v18.16.0):${RESET}"
read -p "> " version_to_install

# Validate input
if [[ ! "$version_to_install" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  print_error "Invalid version format. Please use the format v[major].[minor].[patch], e.g., v18.16.0"
  exit 1
fi

# Check if version is already installed
if echo "$installed_versions" | grep -q "$version_to_install"; then
  print_warning "Node.js ${BOLD}${version_to_install}${RESET} is already installed"
  
  # Ask if user wants to use this version
  echo -e "${TERTIARY}Do you want to switch to this version? (y/n)${RESET}"
  read -p "> " switch_version
  
  if [[ "$switch_version" =~ ^[Yy]$ ]]; then
    print_step "Switching to Node.js ${BOLD}${version_to_install}${RESET}..."
    nvm use "$version_to_install"
    
    if [ $? -eq 0 ]; then
      print_success "Successfully switched to Node.js ${BOLD}${version_to_install}${RESET}"
    else
      print_error "Failed to switch to Node.js ${BOLD}${version_to_install}${RESET}"
    fi
  fi
  
  exit 0
fi

# Install the selected version
print_step "Installing Node.js ${BOLD}${version_to_install}${RESET}..."
nvm install "$version_to_install"

if [ $? -eq 0 ]; then
  print_success "Successfully installed Node.js ${BOLD}${version_to_install}${RESET}"
  
  # Ask if user wants to use this version
  echo -e "${TERTIARY}Do you want to use this version as default? (y/n)${RESET}"
  read -p "> " use_default
  
  if [[ "$use_default" =~ ^[Yy]$ ]]; then
    print_step "Setting Node.js ${BOLD}${version_to_install}${RESET} as default..."
    nvm alias default "$version_to_install"
    
    if [ $? -eq 0 ]; then
      print_success "Successfully set Node.js ${BOLD}${version_to_install}${RESET} as default"
    else
      print_error "Failed to set Node.js ${BOLD}${version_to_install}${RESET} as default"
    fi
  fi
else
  print_error "Failed to install Node.js ${BOLD}${version_to_install}${RESET}"
fi 