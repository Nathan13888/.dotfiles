#!/bin/bash

## SUBMODULES AREN'T COPIED BY DEFAULT; GUIDE TO COPYING SUBMODULES:
## https://git-scm.com/book/en/v2/Git-Tools-Submodules

# CREDIT! Installation script design and inspiration from Tom Hudson's (aka tomnomnom) Dotfiles. Original link: https://github.com/tomnomnom/dotfiles/blob/master/setup.sh

dotfilesDir=$(pwd)

function link {
  dest="${HOME}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

  if [ -h ~/${1} ]; then
    # Existing symlink 
    echo "Removing existing symlink: ${dest}"
    rm ${dest} 

#  elif [ -f "${dest}" ]; then
#    # Existing file
#    echo "Backing up existing file: ${dest}"
#    mv ${dest}{,.${dateStr}}
#
#  elif [ -d "${dest}" ]; then
#    # Existing dir
#    echo "Backing up existing dir: ${dest}"
#    mv ${dest}{,.${dateStr}}
  fi

  echo "Creating new symlink: ${dest}"
  ln -s ${dotfilesDir}/${1} ${dest}
}


# vscode
#link workspace/Git/.vscode
# Just do --> git clone Nathan13888/.vscode

# vim
link .vim
link .vimrc
link .config/nvim

# git
link .gitconfig
link .gitmessage.txt

# Angular
link .angular-config.json

# scidvspc
link .scidvspc
# Bandaged Better Discord
link .config/BetterDiscord
# fish shell
#link .config/fish
link .config/omf

# OH MY ZSH
link .oh-my-zsh
link .aliases
link .zshrc
link .p10k.zsh


## NEED TO ADD OTHER DotFiles
