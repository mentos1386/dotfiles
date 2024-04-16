#!/bin/env bash
set -euo pipefail

source common.sh

# Install basic packages.
# Most other packages are installed via Home Manager.
# Or for GUI applications, they are installed via flatpak.
if [ "$OS_RELEASE" = "fedora" ]; then
  echo_header "==[host] Detected Fedora"
  rpm-ostree install --idempotent --apply-live --allow-inactive -y \
    git git-lfs zsh curl htop wget
elif [ "$OS_RELEASE" = "ubuntu" ]; then
  echo_header "==[host] Detected Ubuntu"
  sudo apt-get update
  sudo apt-get install -y \
    git git-lfs zsh curl htop wget
fi

if [ "$GUI" = "YES" ]; then
  if [ "$OS_RELEASE" = "fedora" ]; then
    echo_header "==[host:fedora] Installing GUI applications"
    rpm-ostree install --idempotent --apply-live --allow-inactive -y \
      kitty \
      gphoto2 v4l2loopback ffmpeg \
      ddcutil

    echo_header "==[host:fedora] Installing docker"
    cat <<EOF | sudo tee /etc/yum.repos.d/docker.repo >/dev/null
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://download.docker.com/linux/fedora/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF
    rpm-ostree install --idempotent --apply-live --allow-inactive -y \
      docker-ce docker-ce-cli \
      containerd.io \
      docker-buildx-plugin \
      docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "== Docker installed, restart will be needed to take effect."
  elif [ "$OS_RELEASE" = "ubuntu" ]; then
    echo_header "==[host:ubuntu] Installing GUI applications"
    sudo apt-get update
    sudo apt-get install -y \
      kitty \
      gphoto2 ffmpeg \
      ddcutil

    echo_header "==[host:ubuntu] Installing flatpak"
    sudo apt-get install -y \
      flatpak gnome-software-plugin-flatpak

    echo_header "==[host:ubuntu] Installing docker"
    sudo apt-get update
    sudo apt-get install ca-certificates
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "== Docker installed, restart will be needed to take effect."
  fi

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
fi

echo_header "==[host] Installing Nix"
if ! nix --version; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable
  nix-channel --update
else
  echo "Already installed, skipping"
fi

echo_header "==[host] Installing Home Manager"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
NIXPKGS_ALLOW_UNFREE=1 ENVIRONMENT=$ENVIRONMENT nix-shell '<home-manager>' -A install

echo_header "==[host] Installing Home Manager packages"
workspace_link nix/home.nix .config/home-manager/home.nix
workspace_link nix/core.nix .config/home-manager/core.nix
workspace_link nix/personal.nix .config/home-manager/personal.nix
workspace_link nix/work.nix .config/home-manager/work.nix
NIXPKGS_ALLOW_UNFREE=1 ENVIRONMENT=$ENVIRONMENT home-manager switch

echo_header "==[host] Use zsh as default shell"
sudo chsh $USER --shell=/bin/zsh

echo_header "==[host] Plug for neovim"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +PlugInstall +qa || true
nvim --headless +PlugUpdate +qa || true
nvim --headless +PlugUpgrade +qa || true
