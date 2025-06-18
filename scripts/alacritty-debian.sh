#!/usr/bin/env bash
set -e
set -x

TEMP_DIR=$(pwd)/temp
GIT_FOLDER=alacritty

sudo apt install curl -y

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup override set stable
rustup update stable

# clone git 
echo "cloning git"
# mkdir -p $TEMP_DIR/$GIT_FOLDER
rm -rf $TEMP_DIR/$GIT_FOLDER
git clone https://github.com/alacritty/alacritty.git $TEMP_DIR/$GIT_FOLDER

# install dependency 
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 scdoc -y

# build
cd $TEMP_DIR/$GIT_FOLDER
#rustup target add x86_64-apple-darwin aarch64-apple-darwin
#make app-universal
cargo build --release

# post build
# install Terminfo
# infocmp alacritty
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# copy binary 
sudo cp target/release/alacritty /usr/local/bin

# mannual page
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null

# copy auto complete into zsh
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

# Update debian alternative binary
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 60

# Clear up
# Remove git folder
rm -rf $TEMP_DIR/$GIT_FOLDER
