#!/bin/bash

GREEN='\033[32m'
RESET='\033[0m'

# Clone the repo
if [ ! -f "tiger" ]; then
    git clone -b dev $USER@git.forge.epita.fr:p/epita-ing-assistants-yaka/tiger-2027/epita-ing-assistants-yaka-tiger-2027-inscription-rennes-11.git ~/tiger-git

    echo -e "${GREEN}=> Tiger project cloned successfully${RESET}"
fi
