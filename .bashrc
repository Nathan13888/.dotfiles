# oh-my-bash
export OSH=~/.oh-my-bash
OSH_THEME="standard"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

completions=(
  git
  composer
  ssh
)

aliases=(
)

plugins=(
  git
  bashmarks
)

source $OSH/oh-my-bash.sh

HISTSIZE=10000

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.exports ] && source ~/.exports

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
