#!/bin/bash

#####################
# INCLUDED DOTFILES #
#####################
# - neovim
# - git
# - angular and node
# - ZSH
# - Oh My ZSH
# - Tmux

dotfilesDir=$(pwd)

function link {
  dest="${HOME}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

  if [ -h ~/${1} ]; then
    # Existing symlink 
    echo "Removing existing symlink: ${dest}"
    rm ${dest} -ivf 
  fi

  echo "Creating new symlink: ${dest}"
  ln -s ${dotfilesDir}/${1} ${dest}
}

# tmux
link .tmux.conf

# vim
link .config/nvim

# git
link .gitconfig
link .gitmessage.txt

# Angular
link .angular-config.json

# Bandaged Better Discord
#link .config/BetterDiscord
# Need to link this to C drive

# OH MY ZSH

link .oh-my-zsh/custom
link .aliases
link .exports
link .zshrc
link .p10k.zsh


## NEED TO ADD OTHER DotFiles
