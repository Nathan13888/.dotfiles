# Run xinit if this is the normal terminal
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

#ZSH_THEME="powerlevel10k/powerlevel10k"
#source ./themes/powerlevel10k/config/p10k-robbyrussell.zsh

# Aliases
## REMOVE ALL DEFAULT ZSH ALIASES
unalias -m '*'
[[ -f ~/.aliases ]] && source ~/.aliases


# Exports
export PYTHONDONTWRITEBYTECODE=1
[ -f ~/.exports ] && source ~/.exports

# GO LANG
#export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

export GOPATH=$HOME/go # the first path in GOPATH is always used to install external packages
export PATH=$PATH:GOPATH/bin
export GOPATH=$GOPATH:$HOME/workspace/scripts

[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

