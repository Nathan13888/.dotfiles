DISABLE_MAGIC_FUNCTIONS=true

# History
SAVEHIST=100000
HISTFILE=$HOME/.zsh_history

# Homebrew
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

#########################
#        ZINIT          #
#########################

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

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-rust \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node

#########################
#        PROMPT         #
#########################

# Load starship theme via zinit
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

#########################
#       PLUGINS         #
#########################

zinit ice wait lucid; zinit light Aloxaf/fzf-tab
zinit ice wait lucid; zinit light jeffreytse/zsh-vi-mode
zinit ice wait lucid; zinit light sobolevn/wakatime-zsh-plugin

# direnv
eval "$(direnv hook zsh)"

#########################
#          FZF          #
#########################

# Preview directory's content with eza/exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath 2>/dev/null || exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

bindkey -s '^F' 'find . -type f | fzf^M'

export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export FZF_DEFAULT_OPTS='--height 90% --layout=reverse'

# Use fd instead of find for path candidates
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

################################################################################

# zshrc.local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

ulimit -c 0 # disable core dumps

################################################################################

#########################
#        ALIASES        #
#########################

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.aliases.local ] && source ~/.aliases.local

#########################
#        EXPORTS        #
#########################

[ -f ~/.exports ] && source ~/.exports
[ -f ~/.exports.local ] && source ~/.exports.local

#########################
#      COMPLETIONS      #
#########################

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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
