# Dot Files

A dotfiles repository containing Nathan's personal dotfiles that he uses with debian/ubuntu systems.

Three other Github repositories for fonts are included as a submodule of this repository.

Use the INSTALL scripts to create new symlinks in a new or existing Debian/Ubuntu system.

# Scripts
- `FULL-INSTALL.sh` --> install everything for a complete Ubuntu system running GNOME
- `MIN-INSTALL.sh` --> install the least dotfiles that do not effect the system (eg. aliases)
- `WSL-INSTALL.sh` --> install in a debian WSL system
- `ETC-INSTALL.sh` --> installing configs that are in `/etc/`
- `EXTRA-INSTALL.sh` --> install other things

- `UPDATE-SUBMODULES.sh` --> update submodules of this respository

# Cloning (with submodules)
*Reference* https://git-scm.com/book/en/v2/Git-Tools-Submodules
### To clone this repository
- `git clone --recurse-submodules https://github.com/Nathan13888/DotFiles`
### To download the submodules (after cloning without `--recurse-submodules`)
- `git clone https://github.com/Nathan13888/DotFiles`
- `git submodule update --init --recursive`

## Dot Files Included

- [x] vimrc
- [x] scidvspc
- [x] vscode (git clone)
- [x] gitconfig
- [x] omf
- [x] fish
- [x] Bandaged Better Discord
- [ ] 

## VIM
Dotfiles mainly contains configs for Neovim.
- Install Vim-Plug (https://github.com/junegunn/vim-plug)
- Run `:PlugInstall` to install all the plugins for vim
- Install YCM using these instructions (https://github.com/ycm-core/YouCompleteMe#linux-64-bit)

## Other Packages not included

## Other Dot File Repositories
- https://github.com/Nathan13888/ChessGames
- https://github.com/Nathan13888/lc0-nets
- https://github.com/Nathan13888/.vscode

# Guides
- https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/
- https://git-scm.com/docs/git-config
- https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
- https://abdullah.today/encrypted-dotfiles/
- https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789




