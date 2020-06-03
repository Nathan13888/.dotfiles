#########
# ALIAS #
#########

## SHORTCUTS
alias vim="nvim" # comment this out if you don't what to use vim
alias sv="sudo vim"
alias v="vim"
alias vr='v -r'
alias g="git"
alias git='hub' # eval "$(hub alias -s)" # what's the difference even??
alias l="less"
alias m="more"
alias s='sudo'
alias sudo='sudo ' # for using other alias when using sudo
alias service="sudo service"
alias serv="service"
alias code="code-insiders"
alias bdctl="betterdiscordctl"
alias chmox='sudo chmod +x'
alias chowm='sudo chown $USER:$USER'
alias su="sudo su -"
alias c="clear"
alias clear="clear -x"
alias reload="omf reload" # reload fish
alias shutdown="sudo shutdown now"
alias reboot="sudo reboot now"

## TYPOS
alias f='g'
alias gi='git'
alias gti='git'
alias cd..="cd .."

## SSH
alias sshdev 'ssh attackercow@192.168.10.69'
alias sshnas 'ssh attackercow@192.168.10.250'
alias sshnvr 'ssh attackercow@192.168.10.140'
alias sshwpc 'ssh tvbox@192.168.10.121'

## INFO and NAVIGATION
alias disks='df -h | grep sd \
    | sed -e "s_/dev/sda[1-9]_\x1b[34m&\x1b[0m_" \
    | sed -e "s_/dev/sd[b-z][1-9]_\x1b[33m&\x1b[0m_" \
    | sed -e "s_[,0-9]*[MG]_\x1b[36m&\x1b[0m_" \
    | sed -e "s_[0-9]*%_\x1b[32m&\x1b[0m_" \
    | sed -e "s_9[0-9]%_\x1b[31m&\x1b[0m_" \
    | sed -e "s_/mnt/[-_A-Za-z0-9]*_\x1b[34;1m&\x1b[0m_"'

alias du="du -h"
alias df="df -h"
alias du1="du -d 1"
alias free="free -hm"
alias uptime='uptime -p'
alias top="htop" # HTOP is better than TOP

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

alias fd='find . -type d -name' # find directory
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
