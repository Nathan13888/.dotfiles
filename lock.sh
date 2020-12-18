#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#fdaaaa'  # default
T='#ee00eeee'  # text
W='#fc0547'  # wrong
V='#bb00bbbb'  # verifying

i3lock \
--insidevercolor=$C \
--ringvercolor=$V \
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
--insidecolor=$B \
--ringcolor=$D \
--linecolor=$B \
--separatorcolor=$D \
--verifcolor=$T \
--wrongcolor=$T \
--timecolor=$T \
--datecolor=$T \
--layoutcolor=$T \
--keyhlcolor=$W \
--bshlcolor=$W \
--screen 1 \
--blur 3 \
--clock \
--indicator \
--timestr="%H:%M:%S" \
--datestr="%A, %m %Y" \
--veriftext="" \
--wrongtext="Nope!" \
--ignore-empty-password --show-failed-attempts
#--timefont=comic-sans \
#--datefont=monofur
#--textsize=20 \
#--modsize=10 \
#--keylayout 1 \
