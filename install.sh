#!/bin/bash
# have to pattern match because * won't find dot files
cp -r dotfiles/.[a-zA-Z0-9]* ~/
crontab cron

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    brew install nnn fzf
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    sudo apt-get install nnn 
fi
