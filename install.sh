#!/bin/bash
cp dotfiles/* ~/
crontab -r
crontab cron
