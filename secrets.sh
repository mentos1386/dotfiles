#!/usr/bin/env bash
set -euo pipefail

##
# In this script, we read secrets from bitwarden
# and store them to OS specific secret store.
#
# Bitwarden requires us to always authenticate, but we do not want
# to do that every time new zsh is started. Storing to OS specific
# secret store avoids that issue as that is bound to the OS user
# session instead.
##

write_secret() {
  if command -v secret-tool >/dev/null; then
    echo "$4" | secret-tool store --label "$3" "$1" "$2"
  elif command -v security >/dev/null; then
    security add-generic-password -s "$1" -a "$2" -w "$4"
  else
    echo "Error: Missing secret-tool and security! Are you on supported OS?"
    exit 1
  fi
}

if ! bw login --check; then
  bw config server https://vault.tjo.space
  bw login
fi

echo "Storing Minstral Codestral API Key..."
write_secret "personal" "minstral-codestral-api-key" "Minstral Codestral API Key" $(bw get notes codestral-minstral-key)

echo "Done!"
