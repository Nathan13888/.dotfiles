TERMINAL=$TERMINAL
echo "TERMINAL is $TERMINAL"

LOG=/tmp/fetchcord.$(date +"%Y%m%d_%H%M%S").log
echo "Logging to $LOG"

echo "Killing all other instances of Fetchcord" | tee $LOG
killall fetchcord

echo "Sleeping for 3 seconds before starting" | tee $LOG
sleep 3
echo "Starting..."

fetchcord --nohardware --nohost --terminal "$TERMINAL" --termfont "MesloLGS Nerd Font" | tee $LOG


