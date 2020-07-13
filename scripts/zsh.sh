CURRENT_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")">/dev/null 2>&1 && pwd -P )

sudo apt -y install zsh git wget curl
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

chsh -s $(which zsh)

cp $CURRENT_PATH/../.zshrc ~/
