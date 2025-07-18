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
      obsidian \
      monitorcontrol
  else
    echo_header "== Installing GUI tools for personal"
    brew install --cask --adopt \
      kitty \
      firefox \
      bitwarden \
      obsidian \
      thunderbird \
      visual-studio-code \
      monitorcontrol
  fi
fi

echo_header "== Configuring macos"
##
# MACOS Configuration
# Ref: https://catalins.tech/how-i-setup-new-macbooks/
##
# Enable tap-to-click for the trackpad and show the correct state in System Preferences
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

# Disable the .DS file creation
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the path bar in the Finder
defaults write com.apple.finder "ShowPathbar" -bool "true"

# Show hidden files in the Finder
defaults write com.apple.finder "AppleShowAllFiles" -bool "false"

# Keep folders on top in Finder
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# Keep folders on top on Desktop
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

killall Finder || true

# Apply the settings
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
