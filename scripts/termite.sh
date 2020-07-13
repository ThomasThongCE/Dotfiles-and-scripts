#!/usr/bin/env bash

CURRENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")">/dev/null 2>&1 && pwd -P )

sudo apt-get install -y \
	git \
	g++ \
	libgtk-3-dev \
	gtk-doc-tools \
	gnutls-bin \
	valac \
	intltool \
	libpcre2-dev \
	libglib3.0-cil-dev \
	libgnutls28-dev \
	libgirepository1.0-dev \
	libxml2-utils \
	gperf\
	libtool
	
git clone --recursive https://github.com/thestinger/termite.git $CURRENT_PATH/termite
git clone https://github.com/thestinger/vte-ng.git $CURRENT_PATH/vte-ng

export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd $CURRENT_PATH/vte-ng
git apply $CURRENT_PATH/../patch/0001-fix-error-empty-struct-definition.patch 
./autogen.sh && make && sudo make install
cd $CURRENT_PATH/termite && make && sudo make install
sudo ldconfig
sudo mkdir -p /lib/terminfo/x; sudo ln -s \
/usr/local/share/terminfo/x/xterm-termite \
/lib/terminfo/x/xterm-termite

sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60

cd $CURRENT_PATH && rm -r termite vte-ng

mkdir -p ~/.config/termite && cp -r $CURRENT_PATH/../config/termite ~/.config/termite/config
