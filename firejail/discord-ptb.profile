include discord.local
include globals.local

noblacklist ${HOME}/.config/discordptb

mkdir ${HOME}/.config/discordptb
whitelist ${HOME}/.config/discordptb

private-bin discord-ptb,electron,electron[0-9],electron[0-9][0-9]
private-opt discord-ptb

# Redirect
include discord-common.profile
