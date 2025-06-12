#!/usr/bin/env bash

# package contain the add-apt-repository
sudo apt install software-properties-common -y

# add ibus-bamboo for vietnamese typing
# Ubuntu repository
# sudo add-apt-repository ppa:bamboo-engine/ibus-bamboo -y
# Debian download from OpenBuildService
DEBIAN_VERSION=$(lsb_release -a | grep Release | awk '{print $2}')
echo "deb http://download.opensuse.org/repositories/home:/lamlng/Debian_\"${DEBIAN_VERSION}\"/ /" | sudo tee /etc/apt/sources.list.d/home:lamlng.list
curl -fsSL https://download.opensuse.org/repositories/home:lamlng/Debian_${DEBIAN_VERSION}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_lamlng.gpg > /dev/null
sudo apt-get update
sudo apt-get install ibus-bamboo ibus -y
ibus restart

# add mozc for japanese typing
sudo apt install ibus-mozc mozc-utils-gui -y

# Populate the variable into /etc/environment file
sudo bash -c 'cat >> /etc/environment << EOF
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus
QT4_IM_MODULE=ibus
CLUTTER_IM_MODULE=ibus
GLFW_IM_MODULE=ibus
EOF'

# Ubuntu setting, This not work in debian version. Please manually setup using ibus-setup
 gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'Bamboo'), ('ibus', 'mozc-jp')]"
gsettings set org.gnome.desktop.input-sources per-window true

