#!/bin/bash
# have to pattern match because * won't find dot files
cp -u dotfiles/.[a-zA-Z0-9]* ~/
crontab -r
crontab cron
