#!/bin/env bash
CONFIG_DIR=$(dirname $(dirname "$(realpath $0)"))

# Kitty terminal
echo "include themes/rose-pine-moon.conf" >$HOME/.config/kitty/theme.conf
kill -SIGUSR1 $(pidof kitty)

# Neovim
kill -SIGUSR1 $(pidof nvim) $(pidof vim) $(pidof vi)

# Bat
sed -i "s/--theme=.*/--theme=OneHalfDark/g" ${CONFIG_DIR}/bat/config

home-manager switch
