#!/usr/bin/env bash

# add ibus-bamboo for vietnamese typing
sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
sudo apt-get update
sudo apt-get install ibus-bamboo
ibus restart

# add mozc for japanese typing
sudo apt -y install `check-language-support -l ja`

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo'), ('ibus', 'mozc-jp')]"

gsettings set org.gnome.desktop.input-sources per-window true

