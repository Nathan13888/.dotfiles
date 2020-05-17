# ALIAS

## COMMANDS
alias git 'hub'
alias lla "ls -alF"
alias lsa "ls -aF"

## SSH
alias sshdev 'ssh attackercow@192.168.10.69'
alias sshnas 'ssh attackercow@192.168.10.250'
alias sshnvr 'ssh attackercow@192.168.10.140'
alias sshwpc 'ssh tvbox@192.168.10.121'


# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
