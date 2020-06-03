#########
# ALIAS #
#########

## SHORTCUTS
alias sv="sudo vim"
alias v="vim"
alias vr='v -r'
alias g="git"
alias git='hub' # eval "$(hub alias -s)" # what's the difference even??
alias l='le'
alias le="less"
alias m='mo'
alias mo="more"
alias s 'sudo'
alias sudo='sudo ' # for using other alias when using sudo
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
alias chmox='sudo chmod +x'
alias chowm='sudo chown $USER:$USER'
alias su="sudo su -"
alias c="clear"
alias cl="clear"
alias cls="clear"
alias clear="clear -x"

## TYPOS
alias gi='git'
alias gti='git'
alias cd..="cd .."
alias f='g'
# This really isn't a problem since I rarely do typos and could easily fix them if I do...

## SSH
alias sshdev 'ssh attackercow@192.168.10.69'
alias sshnas 'ssh attackercow@192.168.10.250'
alias sshnvr 'ssh attackercow@192.168.10.140'
alias sshwpc 'ssh tvbox@192.168.10.121'

## INFO and NAVIGATION
alias lla="ls -AlhF --color=always --group-directories-first" 
alias lld="lla | grep --color=always '^d'"
alias llf="lla | grep --color=always '^-'"
alias lsa="ls -AhF --color=always" # don't think I'd use this very often
alias lsr="ls -R --color=always" # show all directories recursively, useful for small directories

alias mkd="mkdir -vp"
alias smkd="sudo mkdir -vp"

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias du1="du -d 1"

alias fdir='find . -type d -name' # find directory
alias ff='find . -type f -name' # find file

alias pers "cd /mnt/nas/personal"
alias medi "cd /mnt/nas/media"
alias back "cd /mnt/nas/backup"
alias arch "cd /mnt/nas/archival"
alias work "cd ~/workspace"
alias cgit "cd ~/workspace/Git"

alias ..="cd .."
alias ...="cd ../.."
#alias ....="cd ../.."
#alias ......="cd ../../.."
#alias ........="cd ../../../.."
#alias .3='cd ../../..'
#alias .4='cd ../../../..'
#alias .5='cd ../../../../..'
alias 1='cd ..'
alias 2='cd ../..'
alias 3='cd ../../..'
alias 4='cd ../../../..'
alias 5='cd ../../../../..'
#alias ~="cd ~" # using "cd" is faster
#alias -- -="cd -"
