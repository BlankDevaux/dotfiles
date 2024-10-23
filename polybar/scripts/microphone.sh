#!/bin/bash

readonly CMD=$1

readonly COLOR_MUTED="%{F$(grep -P '^secondary' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_MUTED=""
readonly COLOR_UNMUTED="%{F$(grep -P '^main' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_UNMUTED=""

function is_muted {
  mic=$(pacmd list-sources | grep '* index' | awk '{print $3}')
  muted=false
  if [ "$(pactl get-source-mute $mic | awk '{print $2}')" = "no" ]
  then
    muted=false
  else
    muted=true
  fi

  echo "$muted"
}

function show_icon {
  muted=$(is_muted)
  if [ "$muted" = true ]
  then
    echo $COLOR_MUTED$ICON_MUTED
  else
    echo $COLOR_UNMUTED$ICON_UNMUTED
  fi
}

function toggle {
  mic=$(pacmd list-sources | grep '* index' | awk '{print $3}')
  pactl set-source-mute $mic toggle
  muted=$(is_muted)
  if [ "$muted" = true ]
  then
    dunstify "Microphone muted"
  else
    dunstify "Microphone unmuted"
  fi
}

case $CMD in
    
    "--show")
      show_icon
    ;;
    
    "--toggle")
      toggle
    ;;
    
    *)
        echo "Invalid command"
        echo ""
        echo "Available commands :"
        echo "--toggle                   Toggle microphone state"
        echo "--show                     Show icons"
        exit 0
    ;;
    
esac
