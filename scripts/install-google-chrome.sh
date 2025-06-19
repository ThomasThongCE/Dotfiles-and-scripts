#!/usr/bin/env bash

sudo apt install -y curl

curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo dpkg -i google-chrome-stable_current_amd64.deb

sudo apt --fix-broken install

rm google-chrome-stable_current_amd64.deb

