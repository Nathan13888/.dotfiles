#!/bin/bash

# TODO: detect root permissions

dotfilesDir=$(pwd)

function link {
  dest="/etc/${1}"

  # TODO: detect if file already exists

  echo "Creating new symlink: ${dest}"
  ln -s ${dotfilesDir}/${1} ${dest}
}

link macchanger/ifupdown.sh
