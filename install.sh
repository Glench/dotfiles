#!/bin/bash
# have to pattern match because * won't find dot files
cp -r dotfiles/.[a-zA-Z0-9]* ~/
crontab cron

# ignore these filetypes for all git projects
git config --global core.excludesfile ~/.gitignore
