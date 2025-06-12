#!/usr/bin/env bash

sudo apt -y install arc-theme git

#mkdir -p ~/.icons && cd ~/.icons && git clone https://github.com/rtlewis88/rtl88-Themes.git	

# Setting GTK4.0 prefer dark mode
# GTK3.0 setting will be included in ~/.config/gtk3.0/settings.ini
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

