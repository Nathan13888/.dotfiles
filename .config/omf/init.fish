#########
# ALIAS #
#########

## SHORTCUTS
alias v="vim"
alias vr='v -r'
alias g="git"
alias s 'sudo'
alias sudo='sudo ' # for using other alias when using sudo
alias c="clear"
alias free="free -hm"
alias df="df -h"
alias du="du -h"
alias service="sudo service"
alias serv="service"
alias code="code-insiders"
alias bdctl="betterdiscordctl"
alias shutdown="sudo shutdown now"
alias reboot="sudo reboot now"
alias reload="omf reload" # reload fish
alias chmox="sudo chmod +x"
alias chowm="sudo chown $USER:$USER"

## TYPOS
alias gti='git'
alias cl="clear"
alias cls="clear"
alias clear="clear -x"
# This really isn't a problem since I rarely do typos and could easily fix them if I do...

## COMMANDS
alias git 'hub' # eval "$(hub alias -s)" # what's the difference even??
alias lla "ls -alF"
alias lsa "ls -aF"

## SSH
alias sshdev 'ssh attackercow@192.168.10.69'
alias sshnas 'ssh attackercow@192.168.10.250'
alias sshnvr 'ssh attackercow@192.168.10.140'
alias sshwpc 'ssh tvbox@192.168.10.121'

## Navigation
alias cls="c"
alias ..="cd .."
alias cd..="cd .."
alias ....="cd ../.."
alias ......="cd ../../.."
alias ........="cd ../../../.."
#alias ~="cd ~" # using "cd" is faster
#alias -- -="cd -"

# Golang developers might need this one
#set -xg GOPATH $HOME/gocode
set -xg PATH $PATH /usr/local/go/bin/

# Python developers otherwise
set -xg PYTHONDONTWRITEBYTECODE 1
