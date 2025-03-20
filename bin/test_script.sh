#!/bin/bash

GREEN='\033[32m'
RESET='\033[0m'
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../config/"

# Copy test script
rm -f ~/tiger-git/run_tests.sh
cp "$CONFIG_DIR"run_tests.sh ~/tiger-git/

echo -e "${GREEN}=> Test script installed successfully${RESET}"
