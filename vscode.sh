#!/bin/bash
set -euo pipefail

ACTION=
while [[ $# -gt 0 ]]; do
  case $1 in
  --install)
    ACTION=install
    break
    shift
    ;;
  --store)
    ACTION=store
    break
    shift
    ;;
  -h | --help)
    echo "Usage: vscode.sh [--install|--store]"
    exit 0
    ;;
  -* | --*)
    echo "Unknown option $1"
    exit 1
    ;;
  esac
done
if [ -z "$ACTION" ]; then
  echo "No action specified"
  echo "Usage: vscode.sh [--install|--store]"
  exit 1
fi

if [ "$ACTION" = "install" ]; then
  for extension in $(cat code/extensions.txt); do
    code --install-extension $extension
  done
elif [ "$ACTION" = "store" ]; then
  code --list-extensions >code/extensions.txt
fi
