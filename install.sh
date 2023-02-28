#/bin/bash

REPO_DIR=$(dirname $(readlink -f $0))
HOME_DIR=${HOME}

echo "REPO_DIR=${REPO_DIR}"
echo "HOME_DIR=${HOME_DIR}"

workspace_backup() {
  mv $HOME_DIR/$1 $HOME_DIR/$1-old 2>/dev/null || true
}

workspace_link() {
  mkdir -p $(dirname $HOME_DIR/$2)
  ln -s $REPO_DIR/$1 $HOME_DIR/$2 || true
}

if cat /etc/lsb-release | grep Manjaro > /dev/null
then
  echo "== manjaro packages"
  sudo pacman -Syu
  sudo pacman -S \
    git \
    bat \
    difftastic \
    vim \
    neovim \
    zsh \
    tmux \
    nodejs \
    ripgrep \
    typos-bin
elif cat /etc/os-release | grep "Ubuntu" > /dev/null
then
  echo "== ubuntu packages"
  sudo apt update
  sudo apt install -y \
    git \
    bat \
    vim \
    neovim \
    zsh \
    tmux \
    nodejs \
    ripgrep \
    snapd \
    cargo
  sudo snap install \
    difftastic \
    starship \
  cargo install typos-cli
fi

echo "== zplug"
 curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh || true

echo "== starship"
if ! starship --help > /dev/null
then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
fi

echo "== Switching shell to ZSH"
sudo chsh $USER --shell $(which zsh)

echo "== Copying configuration files..."
# GIT
workspace_backup .gitconfig
workspace_link git/gitconfig .gitconfig

# SSH
workspace_backup .ssh/authorized_keys
workspace_link ssh/authorized_keys .ssh/authorized_keys

# TMUX
workspace_backup .tmux.conf
workspace_link tmux/tmux.conf .tmux.conf

# STARSHIP
workspace_backup .starship.toml
workspace_link starship/starship.toml .starship.toml

# ZSH
workspace_backup .zshrc
workspace_link zsh/zshrc .zshrc

# BIN
workspace_backup .bin
workspace_link bin .bin

# ALACRITTY
workspace_backup .alacritty.yml
workspace_link alacritty/alacritty.yml .alacritty.yml

# KITTY
workspace_backup .config/kitty/kitty.conf
workspace_link kitty/kitty.conf .config/kitty/kitty.conf

# BAT
workspace_backup .config/bat/config
workspace_link bat/config .config/bat/config

# VIM
workspace_backup .vimrc
workspace_link vim/vimrc .vimrc
workspace_backup .vim/coc-settings.json
workspace_link vim/coc-settings.json .vim/coc-settings.json

# NEOVIM
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
workspace_backup .config/nvim/init.vim
workspace_link nvim/init.vim .config/nvim/init.vim
workspace_backup .config/nvim/coc-settings.json
workspace_link nvim/coc-settings.json .config/nvim/coc-settings.json
