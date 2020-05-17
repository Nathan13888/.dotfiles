#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# vim
ln -s ${BASEDIR}/vimrc ~/.vimrc
ln -s ${BASEDIR}/vim/ ~/.vim

# git
ln -s ${BASEDIR}/gitconfig ~/.gitconfig

# vscode

ln -s ${BASEDIR}/.vscode ~/workspace/Git/.vscode

# fish
ln -s ${BASEDIR}/fish ~/.config/fish

## NEED TO ADD OTHER DotFiles
