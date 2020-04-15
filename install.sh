#!/bin/bash
# have to pattern match because * won't find dot files
cp -r dotfiles/.[a-zA-Z0-9]* ~/
cp dotfiles/lfrc ~/.config/lf/
crontab cron

if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform
    brew install fzf wget ffmpeg youtube-dl macvim ntfs-3g lf node ripgrep bat tldr
    /usr/local/opt/fzf/install # reverse search and **
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
    sudo apt-get install lf ffmpeg fzf youtube-dl
fi
