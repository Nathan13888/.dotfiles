# Dotfiles

A dotfiles repository containing Nathan's personal dotfiles that he uses with debian/ubuntu systems.

Three other Github repositories for fonts are included as a submodule of this repository.

Use the INSTALL scripts to create new symlinks in a new or existing Debian/Ubuntu system.

## Prep
### WSL
- refer to this [link](https://askubuntu.com/questions/966488/how-do-i-fix-r-command-not-found-errors-running-bash-scripts-in-wsl)
- fix powerline fonts
- remove any existing config files
- install LS_COLORS
- use `dos2unix` to fix any file ending problems
### Arch
- Connecting to wifi: `nmtui`
- Update reflector: `reflector --country Canada --country US --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist`
- Setup GPG: `gpg --list-keys` (init user files), add keyserver, import key
- Add keyserver: `keyserver hkps://keys.openpgp.org`
  * `~/.gnupg/gpg.conf`
  * `/etc/pacman.d/gnupg/gpg.conf`
  * `gpg --recv-keys <key1> <newkey2> ...`
- Populate keys: `sudo pacman-key --populate archlinux`
- Yay: clone `https://aur.archlinux.org/yay.git` and `makepkg -si`
- Install all the packages you need form `PACKAGES.md`
- Configure .local files: git, aliases, exports
### WM
- Install all the WM packages
- Link WM dotfiles
- ~/.Xresources
- ~/.xinitrc

### GPG
- **Import Key**: `gpg --import private.key`
- **Verify Key**: `gpg --edit-key {KEY} trust quit`
#### `~/.gnupg/gpg-agent.conf`:
```
default-cache-ttl 34560000
max-cache-ttl 34560000
pinentry-program /usr/bin/pinentry-gnome3
```
- (pinentry-gnome is needed for gnome-keyring to work)
### Gnome Keyring

### SSH Keys

### Git
- install `git`, `git-lfs`, `hub`, [`git-extras`](https://github.com/tj/git-extras)
- make a .gitconfig.local file
- setup [git credential helper](https://git-scm.com/docs/gitcredentials)
- setup GPG signing key
### Bash
- Oh-my-bash: `bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"`
### ZSH
- install `zsh`: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` and [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
- remove `~/.oh-my-zsh/custom`
#### PowerLevel10k
- Install P10k:`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
#### Starship Prompt
- Installing using curl: `curl -fsSL https://starship.rs/install.sh | bash`
- Alternative, you could get starship from AUR: `starship, starship-bin, starship-git`

### Pipewire
- to change sample rate in `pipewire.conf`: `default.clock.rate = 192000`
- add to end of `/usr/share/pipewire/pipewire.conf`
```
context.exec = [
    { path = "/usr/bin/pipewire" args = "-c pipewire-pulse.conf" }
    { path = "/usr/bin/pipewire-media-session"  args = "" }
]
```

### Tmux
- Installing TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
- Install plugins: "Press prefix + I (capital i, as in Install) to fetch the plugin"
### Nvim
- **Install Vim-Plug**: `sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'`
- Inside neovim, run `:PlugInstall`
- `CocInstall coc-css coc-json coc-python coc-discord coc-sh coc-yaml`
- Install YCM using these instructions (https://github.com/ycm-core/YouCompleteMe#linux-64-bit)
### Firefox
- Download firefox (a gpg key server must be setup to install `firefox-nightly` from AUR)
- Disable `dom.event.contextmenu.enabled` if there are problems with right-click
- Enable `browser.compactmode.show`
- Sync settings
- Disable telemetry and change search engine
- Change device name to be more recognizable
### Discord
- Install `discord` or `discord-ptb`
- Install `betterdiscordctl`
- Run `betterdiscordctl install [-f ptb]`
- Connect dotfiles
- Enable plugins and themes
- Disable `Linux Settings/Minimize to tray` and enable `Settings/Developer Mode`
### Emacs
- Install `emacs`
- Install DOOM:
  - `git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d`
  - `~/.emacs.d/bin/doom install`
### LS_COLORS
Install options:
1. run the **install** script inside the submodule
2. Arch Linux: `lscolors-git` from AUR
### Vivd (LS_COLORS alternative)
- Arch Linux: `vivid` from AUR
- add to .exports.local: `export LS_COLORS="$(vivid generate <theme>)"`
### Wakatime
- install wakatime cli
- add API key
### WireGuard ([quick install](https://www.wireguard.com/quickstart/))
- `apt install wireguard`
- configure wireguard

### Podman
- Refer to: `https://wiki.archlinux.org/title/Podman#Configuration`

### LIMITS
- Realtime: add to end of `/etc/security/limits.conf`:
```
@audio           -       rtprio          95
@audio           -       memlock         unlimited
```

## Scripts
- `install` --> regular install script for a desktop
- `install-server` --> install script for a server
- `UPDATE-SUBMODULES.sh` --> update submodules of this respository

## Cloning (with submodules)
*Reference* https://git-scm.com/book/en/v2/Git-Tools-Submodules
### To clone this repository
- `git clone --recurse-submodules https://github.com/Nathan13888/DotFiles`
### To download the submodules (after cloning without `--recurse-submodules`)
- `git clone https://github.com/Nathan13888/DotFiles`
- `git submodule update --init --recursive`

## Other Dot File Repositories
- https://github.com/Nathan13888/.vscode




