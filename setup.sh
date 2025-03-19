#!/bin/bash

GREEN='\033[32m'
RESET='\033[0m'

set -e  # Exit if any command fails
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting development environment setup..."

# Run all scripts in order
for script in "$SCRIPT_DIR/bin/"*.sh; do
    echo -e "${GREEN}=> Executing ${script}...${RESET}"
    bash "$script"
done

# Open the project
codium tiger

echo -e "${GREEN}
Tiger setup succesfully installed, VSCodium is about to start automatically,
you will find custom buttons for the Tiger Project on the bottom bar.
You can launch anytime VSCodium with the \`codium\` command (not code).${RESET}"
