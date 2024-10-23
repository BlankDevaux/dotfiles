#!/usr/bin/bash

DIR="$HOME/.config/polybar"

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null 
do 
  sleep 0.1
done

MAIN_MONITOR=$(xrandr | grep primary | awk '{print $1}')
SECOND_MONITOR=$(xrandr | grep "\<connected\>" | awk '{i++}i==2'| awk '{print $1}')

MONITOR=$SECOND_MONITOR TRAY_POSITION=right polybar -q main --reload -c "$DIR/config.ini" &
MONITOR=$MAIN_MONITOR TRAY_POSITION=none polybar -q main --reload -c "$DIR/config.ini" &

if pgrep -x "polybar" >/dev/null
then
  dunstify --appname="polybar" --urgency="LOW" "Polybar loaded at $(date +'%T')"
else
  dunstify --appname="polybar" --urgency="CRITICAL" "Polybar not loaded"
fi

