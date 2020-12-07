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

