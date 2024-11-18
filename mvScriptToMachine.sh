#!/usr/bin/env sh
# This script will override the dot file in this machine with the file in this git folder
# The old dot files will be backup as <dotFileName_backup>

# Backup dotfile
cp ~/.zshrc ~/.zshrc_backup
cp ~/.vimrc ~/.vimrc_backup
cp ~/.config/i3/config ~/.config/i3/config_backup
cp ~/.config/i3status/config ~/.config/i3status/config_backup

# Copy script file into this folder
rsync -a .zshrc ~/
rsync -a .vimrc ~/
rsync -a .config/i3/config ~/.config/i3/config
rsync -a .config/i3status/config ~/.config/i3status/config
