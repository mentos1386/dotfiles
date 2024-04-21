#!/usr/bin/env bash
set -euo pipefail

source common.sh

echo_header "== Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"

echo_header "== Installing CLI tools"
brew install git git-lfs zsh curl htop wget

echo_header "== Installing GUI tools"
brew install --cask --adopt \
  kitty \
  orbstack \
  firefox \
  bitwarden \
  obsidian \
  thunderbird \
  visual-studio-code