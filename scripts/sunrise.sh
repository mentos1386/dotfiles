#!/bin/env bash
CONFIG_DIR=$(dirname $(dirname "$(realpath $0)"))

# Kitty terminal
echo "include themes/rose-pine-dawn.conf" >$HOME/.config/kitty/theme.conf
kill -SIGUSR1 $(pidof kitty)

# Neovim
kill -SIGUSR1 $(pidof nvim)

# Bat
sed -i "s/--theme=.*/--theme=OneHalfLight/g" ${CONFIG_DIR}/bat/config

home-manager switch
