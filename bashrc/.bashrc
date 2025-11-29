# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
. "$HOME/.local/share/omarchy/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

. "$HOME/.local/share/../bin/env"

# enable vi-mode
set -o vi

eval "$(tmuxifier init -)"
eval "$(starship init bash)"

alias lzd="lazydocker"
alias lzg="lazygit"
alias vim="nvim"
alias claude-yolo="claude --dangerously-skip-permissions"

# kubernetes stuff
export KUBECONFIG="$HOME/.kube/config"
# FIXME: source kubecompletion plugin for bash

# path adjustments for executable discovery
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

