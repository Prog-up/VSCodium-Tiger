#!/bin/bash

GREEN='\033[32m'
RESET='\033[0m'
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../config/"

# Install VS Codium and extensions
nix profile install nixpkgs#vscodium

echo -e "${GREEN}=> VS Codium installed successfully${RESET}"

codium --install-extension "$CONFIG_DIR"*.vsix
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.23.6/cpptools-linux-x64.vsix
codium --install-extension cpptools-linux-x64.vsix
rm cpptools-linux-x64.vsix
codium --install-extension actboy168.tasks
codium --install-extension eamodio.gitlens
codium --install-extension gruntfuggly.todo-tree
codium --install-extension luozhihao.call-graph

echo -e "${GREEN}=> VS Codium extensions installed successfully${RESET}"

# Configure the settings and theme
if [ ! -f ~/.config/VSCodium/User ]; then
    mkdir -p ~/.config/VSCodium/User
    cp "$CONFIG_DIR"settings.json ~/.config/VSCodium/User/
fi

echo -e "${GREEN}=> VS Codium user side configuration done${RESET}"

# Install VS Code project dotfiles
rm -rf ~/tiger-git/.vscode/
cp -r "$CONFIG_DIR".vscode/ ~/tiger-git/

echo -e "${GREEN}=> VS Codium project side configuration done${RESET}"

