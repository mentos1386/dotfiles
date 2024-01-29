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


if [ ! -n "${TOOLBOX_PATH}" ]
then
  echo "==[host] Installing rpm-os tree packages"
  rpm-ostree install --idempotent --apply-live --allow-inactive \
    git \
    git-lfs \
    neovim \
    bat \
    zsh \
    ripgrep \
    difftastic \
    nodejs

  echo "==[host] Installing flatpaks"
  flatpak install --user com.bitwarden.desktop
  flatpak install --user md.obsidian.Obsidian
  flatpak install --user org.mozilla.firefox
  flatpak install --user org.mozilla.Thunderbird

  echo "==[host] Preparing toolbox"
  toolbox create fedora || true
  toolbox enter fedora
else
  echo "==[toolbox] Installing dependencies"
  sudo dnf update -y --best --allowerasing
  sudo dnf install -y \
    git \
    bat \
    neovim python3-neovim \
    zsh \
    tmux \
    nodejs \
    ripgrep \
    snapd \
    cargo \
    difftastic \
    wl-clipboard \
    ripgrep jq fd-find \
    gcc g++ libstdc++-static
fi

echo "== Prepare ~/.bin"
mkdir -p $HOME/.bin

echo "== starship"
if ! starship --help > /dev/null
then
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --bin-dir=$HOME/.bin --yes
fi

echo "== Switching shell to ZSH"
sudo chsh $USER --shell=$(which zsh)

echo "== Installing fonts"
HOME_FONTS_DIR="${HOME_DIR}/.local/share/fonts"
mkdir -p ${HOME_FONTS_DIR}
rm -rf ${HOME_FONTS_DIR}/dotfiles-fonts
git clone --depth 1 git@github.com:mentos1386/dotfiles-fonts.git ${HOME_FONTS_DIR}/dotfiles-fonts
fc-cache

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

# KITTY
workspace_backup .config/kitty/kitty.conf
workspace_link kitty/kitty.conf .config/kitty/kitty.conf

# BAT
workspace_backup .config/bat/config
workspace_link bat/config .config/bat/config

# NEOVIM
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
workspace_backup .config/nvim/init.vim
workspace_link nvim/init.vim .config/nvim/init.vim
for file in nvim/lua/*
do
  workspace_backup .config/nvim/lua/$(basename $file)
  workspace_link nvim/lua/$(basename $file) .config/nvim/lua/$(basename $file)
done
