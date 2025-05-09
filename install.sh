#!/usr/bin/env bash
set -euo pipefail

GUI=NO
ENVIRONMENT=personal
while [[ $# -gt 0 ]]; do
  case $1 in
  --env)
    ENVIRONMENT=$2
    shift # past argument
    shift # past value
    ;;
  --gui)
    GUI=YES
    shift # past argument
    ;;
  -h | --help)
    echo "Usage: install.sh [--gui]"
    exit 0
    ;;
  -*)
    echo "Unknown option $1"
    exit 1
    ;;
  esac
done

source common.sh

echo_header "== DotFiles with GUI: $GUI and ENV: $ENVIRONMENT"

LINUX="true"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo_header "== Detected linux"
  ENVIRONMENT=$ENVIRONMENT GUI=$GUI ./install-linux.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  LINUX="false"
  echo_header "== Detected macos"
  ENVIRONMENT=$ENVIRONMENT GUI=$GUI ./install-macos.sh
else
  echo "Error: ${OSTYPE} is not supported!"
  exit 1
fi

echo_header "== Installing Nix"
if ! command -v nix; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable
  nix-channel --update
else
  echo "Already installed, skipping"
fi

echo_header "== Installing Home Manager"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
NIXPKGS_ALLOW_UNFREE=1 ENVIRONMENT=$ENVIRONMENT nix-shell '<home-manager>' -A install

echo_header "== Installing Home Manager packages"
workspace_link nix/home.nix .config/home-manager/home.nix
workspace_link nix/core.nix .config/home-manager/core.nix
workspace_link nix/personal.nix .config/home-manager/personal.nix
workspace_link nix/work.nix .config/home-manager/work.nix
NIXPKGS_ALLOW_UNFREE=1 ENVIRONMENT=$ENVIRONMENT home-manager switch

echo_header "== Use zsh as default shell"
if [ "${LINUX}" == "true" ]; then
  sudo usermod --shell /usr/bin/zsh ${USER}
fi

echo_header "== Plug for neovim"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim --headless +PlugInstall +qa || true
nvim --headless +PlugUpdate +qa || true
nvim --headless +PlugUpgrade +qa || true

if command -v code; then
  echo_header "== Installing vscode extensions"
  ./vscode.sh --install
fi
