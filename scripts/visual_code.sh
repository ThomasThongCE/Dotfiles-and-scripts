#!/usr/bin/env bash

OUTPUT_FILE_NAME="code-latest.deb"

sudo apt install -y wget jq
wget -O "$OUTPUT_FILE_NAME" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

if [ $? -eq 0 ]; then
  echo "Successfully downloaded $OUTPUT_FILE_NAME"
else
  echo "Failed to download $OUTPUT_FILE_NAME"
  exit 1
fi

# Install apt repository on installation process
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections

sudo apt install "./$OUTPUT_FILE_NAME"
rm "$OUTPUT_FILE_NAME"

# TODO: Automically add "password-store": "gnome-libsecret" into ~/.vscode/argv.json
#
