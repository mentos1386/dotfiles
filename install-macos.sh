#!/usr/bin/env bash
set -euo pipefail

source common.sh

echo_header "== Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"

echo_header "== Installing CLI tools"
brew install git git-lfs zsh bash curl htop wget colima docker docker-buildx

colima start --cpu 8 --memory 12 --disk 200 --vm-type=vz --vz-rosetta --mount-type=virtiofs

if [ "$GUI" = "YES" ]; then
  if [ "$ENVIRONMENT" = "work" ]; then
    echo_header "== Installing GUI tools for work"
    brew install --cask --adopt \
      kitty \
      bitwarden \
      obsidian
  else
    echo_header "== Installing GUI tools for personal"
    brew install --cask --adopt \
      kitty \
      firefox \
      bitwarden \
      obsidian \
      thunderbird \
      visual-studio-code
  fi
fi
