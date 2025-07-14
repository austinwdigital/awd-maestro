#!/bin/bash

# AWDHAUS Maestro - Node.js Version Switcher
# Allows switching between installed Node.js versions

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

print_section "NODE.JS VERSION SWITCHER"
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

# Display installed versions with current one highlighted
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

# Display available major versions
echo -e "${TERTIARY}Available Node.js major versions:${RESET}"
echo

# Initialize variables
major_versions=""

# Get unique major versions while preserving the "v" prefix
for version in $installed_versions; do
  # Extract major version number (e.g., v12.34.56 -> 12)
  major_num=$(echo "$version" | cut -d. -f1 | sed 's/v//')
  major_versions="$major_versions $major_num"
done

# Get unique major versions
unique_majors=$(echo "$major_versions" | tr ' ' '\n' | sort -n | uniq)

# Display each major version with its latest minor/patch
for major in $unique_majors; do
  # Find the latest version for this major
  latest_version=$(echo "$installed_versions" | grep "^v$major\." | sort -V | tail -1)
  
  # Check if this is the current version's major
  current_major=$(echo "$current_version" | cut -d. -f1 | sed 's/v//')
  
  if [[ "$major" == "$current_major" ]]; then
    echo -e "  ${SUCCESS}${BOLD}v$major${RESET} ${TERTIARY}(current: $latest_version)${RESET}"
  else
    echo -e "  v$major ${GRAY}(latest: $latest_version)${RESET}"
  fi
done

echo
read -p "Enter Node.js major version (e.g. 18, 20): " major_version

# Validate input
if [[ ! "$major_version" =~ ^[0-9]+$ ]]; then
  print_error "Invalid version number"
  exit 1
fi

# Set version to use
version="$major_version"

# Find the latest version for the selected major version
latest_for_major=$(echo "$installed_versions" | grep "^v$version\." | sort -V | tail -1)
if [ -z "$latest_for_major" ]; then
  print_error "No installed Node.js version found for major version $version"
  exit 1
fi

# Switch to the selected version
print_step "Switching to Node.js ${BOLD}${latest_for_major}${RESET}..."

# Use the latest version for the selected major
nvm use "$latest_for_major"

if [ $? -eq 0 ]; then
  # Set as default to persist between sessions
  print_step "Setting ${BOLD}${latest_for_major}${RESET} as default Node.js version..."
  nvm alias default "$latest_for_major"
  
  if [ $? -eq 0 ]; then
    print_success "Successfully set ${BOLD}${latest_for_major}${RESET} as default Node.js version"
  else
    print_error "Failed to set default Node.js version"
  fi
  
  print_success "Successfully switched to Node.js ${BOLD}${latest_for_major}${RESET}"
else
  print_error "Failed to switch to Node.js ${BOLD}${latest_for_major}${RESET}"
fi 