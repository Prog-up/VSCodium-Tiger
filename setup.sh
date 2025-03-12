#!/bin/bash

# Install VS Code and extensions
nix profile install nixpkgs#vscodium
wget https://github.com/microsoft/vscode-cpptools/releases/download/v1.23.6/cpptools-linux-x64.vsix
codium --install-extension cpptools-linux-x64.vsix
rm cpptools-linux-x64.vsix
codium --install-extension actboy168.tasks
codium --install-extension eamodio.gitlens
codium --install-extension gruntfuggly.todo-tree
wget https://github.com/babyraging/yash/releases/download/v0.3.0/yash-0.3.0.vsix
codium --install-extension yash-0.3.0.vsix
rm yash-0.3.0.vsix

# Clone the repo
rm -rf tiger
git clone $USER@git.forge.epita.fr:p/epita-ing-assistants-yaka/tiger-2027/epita-ing-assistants-yaka-tiger-2027-inscription-rennes-11.git tiger

# Setup tasks
mkdir tiger/.vscode
echo "{
    \"version\": \"2.0.0\",
    \"tasks\": [
        {
            \"label\": \"Tiger: setup\",
            \"type\": \"shell\",
            \"command\": \"nix\",
            \"args\": [
                \"run\",
                \"nixpkgs#nixVersions.nix_2_25\",
                \"--\",
                \"develop\",
                \"--command\",
                \"sh\",
                \"-c\",
                \"libtoolize && ./bootstrap && ./configure CXXFLAGS='-std=c++20 -O0 -g -fno-inline'\"
            ],
            \"group\": {
                \"kind\": \"build\",
                \"isDefault\": true
            },
            \"problemMatcher\": []
        },
        {
            \"label\": \"Tiger: check\",
            \"type\": \"shell\",
            \"command\": \"nix\",
            \"args\": [
                \"run\",
                \"nixpkgs#nixVersions.nix_2_25\",
                \"--\",
                \"develop\",
                \"--command\",
                \"sh\",
                \"-c\",
                \"make\",
                \"check\",
                \"-j\",
                \"8\"
            ],
            \"group\": {
                \"kind\": \"test\",
                \"isDefault\": true
            },
            \"problemMatcher\": []
        },
        {
            \"label\": \"Tiger: build\",
            \"type\": \"shell\",
            \"command\": \"nix\",
            \"args\": [
                \"run\",
                \"nixpkgs#nixVersions.nix_2_25\",
                \"--\",
                \"develop\",
                \"--command\",
                \"sh\",
                \"-c\",
                \"make\",
                \"-j\",
                \"8\"
            ],
            \"group\": {
                \"kind\": \"build\",
                \"isDefault\": true
            },
            \"problemMatcher\": []
        },
        {
            \"label\": \"Tiger: clean\",
            \"type\": \"shell\",
            \"command\": \"nix\",
            \"args\": [
                \"run\",
                \"nixpkgs#nixVersions.nix_2_25\",
                \"--\",
                \"develop\",
                \"--command\",
                \"sh\",
                \"-c\",
                \"make distclean;rm -rf Makefile.in aclocal.m4 autom4te.cache/ build-aux/config.guess build-aux/config.sub build-aux/depcomp build-aux/install-sh build-aux/install-sh~ build-aux/ltmain.sh build-aux/m4/libtool.m4 build-aux/m4/ltoptions.m4 build-aux/m4/ltsugar.m4 build-aux/m4/ltversion.m4 build-aux/m4/lt~obsolete.m4 build-aux/missing build-aux/py-compile config.h.in configure src/parse/location.hh src/parse/parsetiger.cc src/parse/parsetiger.hh src/parse/parsetiger.html src/parse/parsetiger.output src/parse/parsetiger.stamp src/parse/parsetiger.xml src/parse/scantiger.cc src/parse/scantiger.hh tcsh/Makefile.in tcsh/python/Makefile.in tcsh/python/swig.mk tests/Makefile.in\"
            ],
            \"group\": {
                \"kind\": \"build\",
                \"isDefault\": false
            },
            \"problemMatcher\": []
        }
    ]
}
" >tiger/.vscode/tasks.json

# Configure the settings and theme
rm -rf ~/.config/VSCodium
mkdir -p ~/.config/VSCodium/User
echo "{
    \"window.customTitleBarVisibility\": \"windowed\",
    \"window.titleBarStyle\": \"custom\",
    \"files.insertFinalNewline\": true,
    \"files.autoSave\": \"afterDelay\",
    \"editor.formatOnSave\": true,
    \"files.associations\": {
        \"*.ll\": \"lex\"
    }
}" >~/.config/VSCodium/User/settings.json

# Open the project
codium tiger

echo "
Tiger setup succesfully installed, VSCodium is about to start automatically,
you will find 4 custom buttons for the Tiger Project on the bottom bar.
You can launch anytime VSCodium with the \`codium\` command (not code)."
