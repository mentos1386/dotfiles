#!/usr/bin/env bash
set -euo pipefail

source common.sh
OS_RELEASE=$(cat /etc/os-release | grep -E "^ID=" | cut -d= -f2)

# Install basic packages.
# Most other packages are installed via Home Manager.
# Or for GUI applications, they are installed via flatpak.
if [ "$OS_RELEASE" = "fedora" ]; then
  echo_header "== Detected Fedora"
  rpm-ostree install --idempotent --apply-live --allow-inactive -y \
    git git-lfs zsh curl htop wget
elif [ "$OS_RELEASE" = "ubuntu" ]; then
  echo_header "== Detected Ubuntu"
  sudo apt-get update
  sudo apt-get install -y \
    git git-lfs zsh curl htop wget
fi

if [ "$GUI" = "YES" ]; then
  if [ "$OS_RELEASE" = "fedora" ]; then
    echo_header "==[fedora] Installing GUI applications"
    rpm-ostree install --idempotent --apply-live --allow-inactive -y \
      kitty \
      gphoto2 v4l2loopback ffmpeg \
      ddcutil

    echo_header "==[fedora] Installing docker"
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
    echo_header "==[ubuntu] Installing GUI applications"
    sudo apt-get update
    sudo apt-get install -y \
      kitty \
      gphoto2 ffmpeg \
      ddcutil

    echo_header "==[ubuntu] Installing flatpak"
    sudo apt-get install -y \
      flatpak gnome-software-plugin-flatpak

    echo_header "==[ubuntu] Installing docker"
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

  echo_header "== Installing flatpaks"
  flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  flatpak install -y --user \
    com.bitwarden.desktop \
    md.obsidian.Obsidian \
    org.mozilla.firefox \
    org.mozilla.Thunderbird \
    org.gnome.Builder \
    com.vscodium.codium

  echo_header "== Installing fonts"
  HOME_FONTS_DIR="${HOME_DIR}/.local/share/fonts"
  mkdir -p ${HOME_FONTS_DIR}
  rm -rf ${HOME_FONTS_DIR}/dotfiles-fonts
  git clone --depth 1 git@github.com:mentos1386/dotfiles-fonts.git ${HOME_FONTS_DIR}/dotfiles-fonts
  fc-cache
fi

