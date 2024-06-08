#!/usr/bin/env bash

source common.sh
echo_header "== DotFiles with ENV: $ENVIRONMENT"

echo_header "==[host] Installing Home Manager packages"
workspace_link nix/home.nix .config/home-manager/home.nix
workspace_link nix/core.nix .config/home-manager/core.nix
workspace_link nix/personal.nix .config/home-manager/personal.nix
workspace_link nix/work.nix .config/home-manager/work.nix

export NIXPKGS_ALLOW_UNFREE=0
export ENVIRONMENT=$ENVIRONMENT
home-manager switch
