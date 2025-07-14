#!/bin/bash

# AWD Maestro - Node.js Version Remover
# Allows removing installed Node.js versions

set -e
set -o pipefail

# Add timeout to prevent script from hanging
TIMEOUT=30
export TMOUT=$TIMEOUT

# Function to handle timeout
handle_timeout() {
  echo
  print_error "Operation timed out after $TIMEOUT seconds"
  exit 1
}

# Set timeout handler
trap handle_timeout ALRM

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NODE.JS VERSION REMOVER"
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
# Try multiple methods to get installed versions
installed_versions=$(nvm ls --no-colors 2>/dev/null | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | sort -V | uniq)

# If that didn't work, try a different approach
if [ -z "$installed_versions" ]; then
  print_warning "Trying alternative method to get Node.js versions..."
  installed_versions=$(find "$NVM_DIR/versions/node" -maxdepth 1 -type d -name "v*" 2>/dev/null | xargs -n1 basename 2>/dev/null | sort -V)
fi

# Check if we found any versions
if [ -z "$installed_versions" ]; then
  print_error "No Node.js versions found. Please install Node.js first with 'nvm install <version>'."
  exit 1
fi

# Display installed versions
echo
if [ -z "$installed_versions" ]; then
  print_warning "No Node.js versions installed via NVM"
  exit 0
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

# Display available versions for selection
echo -e "${TERTIARY}Select Node.js version to remove:${RESET}"
echo

# Create a simple numbered list
i=1
for v in $installed_versions; do
  if [[ "$v" == "$current_version" ]]; then
    echo -e "  ${i}) ${SUCCESS}${BOLD}${v}${RESET} ${TERTIARY}(current)${RESET}"
  else
    echo -e "  ${i}) ${v}"
  fi
  i=$((i+1))
done

echo
read -p "Enter number (1-$((i-1))): " choice_num

# Validate input
if [[ ! "$choice_num" =~ ^[0-9]+$ ]] || [ "$choice_num" -lt 1 ] || [ "$choice_num" -gt $((i-1)) ]; then
  print_error "Invalid selection"
  exit 1
fi

# Get selected version
version_to_remove=$(echo "$installed_versions" | sed -n "${choice_num}p")

# Check if trying to remove current version
if [[ "$version_to_remove" == "$current_version" ]]; then
  print_warning "You're trying to remove the currently active Node.js version"
  echo -e "${TERTIARY}Are you sure you want to continue? (y/n)${RESET}"
  read -t 20 -p "> " confirm || {
    echo
    print_error "Input timed out after 20 seconds"
    exit 1
  }
  
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Operation cancelled"
    exit 0
  fi
fi

print_step "Removing Node.js ${BOLD}${version_to_remove}${RESET}..."
nvm uninstall "$version_to_remove"

if [ $? -eq 0 ]; then
  print_success "Successfully removed Node.js ${BOLD}${version_to_remove}${RESET}"
else
  print_error "Failed to remove Node.js ${BOLD}${version_to_remove}${RESET}"
fi

# Check if we have any versions left
remaining_versions=$(nvm ls --no-colors | grep -v "default" | grep -o "v[0-9]\+\.[0-9]\+\.[0-9]\+" | sort -V)
if [ -z "$remaining_versions" ]; then
  print_warning "No Node.js versions remaining. Consider installing a version."
else
  print_info "Remaining installed versions:"
  for version in $remaining_versions; do
    echo -e "  ${GRAY}${version}${RESET}"
  done
fi 