## If not in tmux, start tmux.
#if [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]]; then
#  exec tmux
#fi

zmodload zsh/zprof

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS=true

# History
SAVEHIST=100000
HISTFILE=$HOME/.zsh_history
#HIST_STAMPS="mm/dd/yyyy"

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


function zcompile-many() {
  local f
  for f; do zcompile -R -- "$f".zwc "$f"; done
}

#########################
#        ZINIT          #
#########################

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


#########################
#        PROMPT         #
#########################


#zinit light spaceship-prompt/spaceship-prompt

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

#zinit ice wait lucid; zinit light junegunn/fzf
zinit ice wait lucid; zinit light Aloxaf/fzf-tab

zinit ice wait lucid; zinit light jeffreytse/zsh-vi-mode

#########################
#          FZF          #
#########################

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_DEFAULT_COMMAND='rg --files --no-ignore'
export FZF_DEFAULT_OPTS='--height 90% --layout=reverse --border'

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


################################################################################

# Nice to have plugins
zinit ice wait lucid; zinit light sobolevn/wakatime-zsh-plugin

# zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

unfunction zcompile-many
ulimit -c 0 # disable core dumps

################################################################################

#########################
#        ALIASES        #
#########################

## REMOVE ALL DEFAULT ZSH ALIASES
#unalias -m '*'
zinit ice wait lucid; [ -f ~/.aliases ] && source ~/.aliases
zinit ice wait lucid; [ -f ~/.aliases.local ] && source ~/.aliases.local


#########################
#        EXPORTS        #
#########################

export PYTHONDONTWRITEBYTECODE=1
[ -f ~/.exports ] && source ~/.exports
[ -f ~/.exports.local ] && source ~/.exports.local


#########################
#      COMPLETIONS      #
#########################

# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

#rustup completions zsh cargo > ~/.zfunc/_cargo
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)


# Compinit, Zinit zicdreplay
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions


unsetopt BEEP
unsetopt LIST_BEEP

#zprof
