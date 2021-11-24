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

echo "== zplug"
 curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh || true

echo "== starship"
if ! starship --help > /dev/null
then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" --yes
fi

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

# VIM
workspace_backup .vimrc
workspace_link vim/vimrc .vimrc
workspace_backup .vim/coc-settings.json
workspace_link vim/coc-settings.json .vim/coc-settings.json
