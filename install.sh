#/bin/bash

REPO_DIR=$(dirname $(readlink -f $0))
HOME_DIR=${HOME}
OS_RELEASE=$(cat /etc/os-release | grep -E "^ID=" | cut -d= -f2)

echo_header() {
  bold=$(tput bold)
  normal=$(tput sgr0)
  red=$(tput setaf 1)
  echo "${bold}${red}$1${normal}"
}

workspace_link() {
  mkdir -p $(dirname $HOME_DIR/$2)
  ln -s $REPO_DIR/$1 $HOME_DIR/$2 || true
}

if [ "$OS_RELEASE" = "fedora" ]; then
  # We treat fedora install as gui. Think PC, Laptop etc.
  echo_header "==[host] Detected Fedora"
  # On host we only install minimal dependencies.
  # Mostly just GUI applications.
  echo_header "==[host] Installing rpm-os tree packages"
  rpm-ostree install --idempotent --apply-live --allow-inactive -y \
    git git-lfs \
    kitty zsh \
    podman-docker \
    gphoto2 v4l2loopback ffmpeg \
    ddcutil

  echo_header "==[host] Installing flatpaks"
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y --user \
    com.bitwarden.desktop \
    md.obsidian.Obsidian \
    org.mozilla.firefox \
    org.mozilla.Thunderbird \
    org.gnome.Builder \
    com.vscodium.codium

  echo_header "==[host] Installing fonts"
  HOME_FONTS_DIR="${HOME_DIR}/.local/share/fonts"
  mkdir -p ${HOME_FONTS_DIR}
  rm -rf ${HOME_FONTS_DIR}/dotfiles-fonts
  git clone --depth 1 git@github.com:mentos1386/dotfiles-fonts.git ${HOME_FONTS_DIR}/dotfiles-fonts
  fc-cache
elif [ "$OS_RELEASE" = "ubuntu" ]; then
  # We treat ubuntu install as non gui. Think WSL, VM etc.
  echo_header "==[host] Detected Ubuntu"
  sudo apt update
  sudo apt install -y \
    git git-lfs zsh
fi

echo_header "==[host] Installing Nix"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update

echo_header "==[host] Installing Home Manager"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

echo_header "==[host] Installing Home Manager packages"
workspace_link nix/home.nix .config/home-manager/home.nix
home-manager switch

echo_header "==[host] Use zsh as default shell"
sudo chsh $USER --shell=/bin/zsh

echo_header "==[host] Plug for neovim"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +'PlugInstall --sync' +qa
nvim --headless +UpdateRemotePlugins +qa
