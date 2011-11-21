#!/bin/bash
cp .vimrc ~/
cp .profile ~/
cp .bashrc ~/
cp .inputrc ~/
crontab -r
crontab cron
