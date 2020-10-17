#!/bin/bash

dotfilesDir=$(pwd)

function unlink {
  dest="${HOME}/${1}"

  echo "Removing existing symlink: ${dest}"
  # Remove Symlink
  rm ${dest}
  echo "Moving Dotfile(s) to original location"
  # Move Dotfiles
  mv ${dotfilesDir}/${1} ${dest}
}

## PUT WHAT EVER YOU WANT BELOW TO REMOVE THE SYMLINK

unlink .config/fish
