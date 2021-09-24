zmodload zsh/zprof

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

HISTSIZE=100000
#HISTFILE=$HOME/.zsh_history

#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# CHT.SH Autocomplete
#fpath=(~/.zsh.d/ $fpath)

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_DEFAULT_OPTS='--height 70% --layout=reverse --border'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

[ -n "$BASH" ] && complete -F _fzf_complete_doge -o default -o bashdefault doge

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;; #'exa -1 --color=always $realpath'
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk


#########################
#        PROMPT         #
#########################

#eval "$(starship init zsh)"
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

# Load starship theme
zinit ice as"command" from"gh-r" \ # `starship` binary as command, from github release
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \ # starship setup at clone(create init.zsh, completion)
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

#PS1="READY > "
#zinit ice wait'!0'
zinit ice wait lucid; zinit light sobolevn/wakatime-zsh-plugin
zinit ice wait lucid; zinit light junegunn/fzf
#zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit ice wait lucid; zinit light zsh-users/zsh-autosuggestions
#zinit ice wait lucid; zinit light zsh-autocomplete
zinit ice wait lucid; zinit light zsh-users/zsh-syntax-highlighting
#zinit ice wait lucid; zinit light Aloxaf/fzf-tab

#zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# Run xinit if this is the normal terminal
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

# Aliases
## REMOVE ALL DEFAULT ZSH ALIASES
#unalias -m '*'
[[ -f ~/.aliases ]] && source ~/.aliases

# Exports
export PYTHONDONTWRITEBYTECODE=1
[ -f ~/.exports ] && source ~/.exports
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go # the first path in GOPATH is always used to install external packages
export PATH=$PATH:$GOPATH/bin
export GOPATH=$GOPATH:$HOME/ws/scripts:$HOME/ws/gt
export PYTHONDONTWRITEBYTECODE=1

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#rustup completions zsh cargo > ~/.zfunc/_cargo

#[ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh
