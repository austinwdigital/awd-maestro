#!/bin/bash

# AWDHAUS Maestro - NPM Cleaner
# Cleans NPM cache and temporary data

set -e
set -o pipefail

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bin/common.sh"

print_header

print_section "NPM CLEANER"
echo

# Check if NPM is installed
if ! command -v npm &> /dev/null; then
  print_error "NPM is not installed. Please install Node.js first."
  exit 1
fi

# Get NPM cache size before cleaning
print_step "Calculating NPM cache size..."
cache_dir=$(npm config get cache)
cache_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)

if [ -z "$cache_size" ]; then
  print_warning "Could not determine cache size"
else
  print_info "Current NPM cache size: ${BOLD}${cache_size}${RESET}"
fi
echo

# Clean NPM cache
print_step "Cleaning NPM cache..."
npm cache clean --force

if [ $? -eq 0 ]; then
  print_success "NPM cache cleaned successfully"
else
  print_error "Failed to clean NPM cache"
fi
echo

# Verify cache is clean
print_step "Verifying NPM cache..."
npm cache verify

if [ $? -eq 0 ]; then
  print_success "NPM cache verified"
else
  print_warning "NPM cache verification failed"
fi
echo

# Clean temporary files
print_step "Cleaning temporary NPM files..."
temp_files_count=$(find /tmp -name "npm-*" 2>/dev/null | wc -l)
rm -rf /tmp/npm-*

print_info "Removed ${BOLD}${temp_files_count}${RESET} temporary NPM files"
echo

# Get new cache size
new_cache_size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1)
if [ -n "$cache_size" ] && [ -n "$new_cache_size" ]; then
  print_success "NPM cache reduced from ${BOLD}${cache_size}${RESET} to ${BOLD}${new_cache_size}${RESET}"
fi 