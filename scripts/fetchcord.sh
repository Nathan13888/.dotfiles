#!/bin/sh -e

TERMINAL=$TERMINAL

LOG=/tmp/fetchcord.$(date +"%Y%m%d_%H%M%S").log
echo "Logging to $LOG"

echo "TERMINAL is $TERMINAL" | tee $LOG

#echo "Killing all other instances of Fetchcord" | tee $LOG
#killall fetchcord.sh
#killall fetchcord

echo "Sleeping for 3 seconds before starting" | tee $LOG
sleep 3
echo "Starting..."

#--termfont "MesloLGS Nerd Font" 
/usr/bin/fetchcord --nohardware --nohost --terminal "$TERMINAL" | tee $LOG

echo "Stopping..."

