#!/usr/bin/env bash

ENVIRONMENT=personal
while [[ $# -gt 0 ]]; do
  case $1 in
  --env)
    ENVIRONMENT=$2
    shift # past argument
    shift # past value
    ;;
  -h | --help)
    echo "Usage: switch.sh [--env=work|personal]"
    exit 0
    ;;
  -*)
    echo "Unknown option $1"
    exit 1
    ;;
  esac
done

source common.sh
echo_header "== DotFiles with ENV: $ENVIRONMENT"

echo_header "==[host] Installing Home Manager packages"
workspace_link nix/flake.nix .config/home-manager/flake.nix
workspace_link nix/core.nix .config/home-manager/core.nix
workspace_link nix/personal.nix .config/home-manager/personal.nix
workspace_link nix/work.nix .config/home-manager/work.nix

export NIXPKGS_ALLOW_UNFREE=0
export ENVIRONMENT=$ENVIRONMENT
home-manager switch
