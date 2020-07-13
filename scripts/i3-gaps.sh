#!/usr/bin/env bash

CURRENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")">/dev/null 2>&1 && pwd -P )

sudo apt -y install i3 i3blocks fonts-font-awesome feh compton redshift git nm-applet thunar lxappearance flameshot alsa

sudo apt -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-xrm-dev xcb libxcb-shape0-dev

git clone https://www.github.com/Airblader/i3 $CURRENT_PATH/i3-gaps
cd $CURRENT_PATH/i3-gaps
git checkout gaps && git pull
autoreconf --force --install
rm -rf build
mkdir build
cd build
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

rm -r $CURRENT_PATH/i3-gaps

cp -r $CURRENT_PATH/../config/i3* ~/.config/
