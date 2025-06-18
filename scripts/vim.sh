#!/usr/bin/env bash

CURRENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")">/dev/null 2>&1 && pwd -P )

sudo apt -y install vim curl

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp $CURRENT_PATH/../.vimrc ~/.vimrc

vim +'PlugInstall --sync' +qa
