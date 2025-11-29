#!/bin/sh

. ./install-zsh.sh
. ./install-tmux.sh
. ./install-stow.sh
. ./install-starship.sh
. ./install-dotfiles.sh

./set-shell.sh

# this probably won't work if bash is the default shell because set-shell requires a restart
./install-omz.sh
