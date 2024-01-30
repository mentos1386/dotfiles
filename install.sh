#/bin/bash

REPO_DIR=$(dirname $(readlink -f $0))
HOME_DIR=${HOME}

workspace_link() {
  mkdir -p $(dirname $HOME_DIR/$2)
  ln -s $REPO_DIR/$1 $HOME_DIR/$2 || true
}

# On host we only install minimal dependencies.
# Mostly just GUI applications.
echo "==[host] Installing rpm-os tree packages"
rpm-ostree install --idempotent --apply-live --allow-inactive \
  git git-lfs \
  kitty zsh

echo "==[host] Installing flatpaks"
flatpak install --user com.bitwarden.desktop
flatpak install --user md.obsidian.Obsidian
flatpak install --user org.mozilla.firefox
flatpak install --user org.mozilla.Thunderbird
flatpak install --user org.gnome.Builder
flatpak install --user com.vscodium.codium

echo "==[host] Installing Nix"
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

echo "==[host] Installing Home Manager"
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install
workspace_link nix/home.nix .config/home-manager/home.nix

echo "==[host] Installing Home Manager packages"
home-manager switch

echo "==[host] Use zsh as default shell"
sudo chsh $USER --shell=/bin/zsh

echo "==[host] Installing fonts"
HOME_FONTS_DIR="${HOME_DIR}/.local/share/fonts"
mkdir -p ${HOME_FONTS_DIR}
rm -rf ${HOME_FONTS_DIR}/dotfiles-fonts
git clone --depth 1 git@github.com:mentos1386/dotfiles-fonts.git ${HOME_FONTS_DIR}/dotfiles-fonts
fc-cache
