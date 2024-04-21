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

GUI=NO
ENVIRONMENT=personal
while [[ $# -gt 0 ]]; do
  case $1 in
  --env)
    ENVIRONMENT=$2
    if [ "$ENVIRONMENT" != "personal" ] && [ "$ENVIRONMENT" != "work" ]; then
      echo "Unknown environment $ENVIRONMENT"
      exit 1
    fi
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
  -* | --*)
    echo "Unknown option $1"
    exit 1
    ;;
  esac
done