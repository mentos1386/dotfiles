#!/usr/bin/env bash

REPO_DIR=$(dirname $(readlink -f $0))
HOME_DIR=${HOME}

echo_header() {
  bold=$(tput bold)
  normal=$(tput sgr0)
  red=$(tput setaf 1)
  echo "${bold}${red}$1${normal}"
}

workspace_link() {
  mkdir -p $(dirname $HOME_DIR/$2)
  rm $HOME_DIR/$2 || true
  ln -s $REPO_DIR/$1 $HOME_DIR/$2 || true
}
