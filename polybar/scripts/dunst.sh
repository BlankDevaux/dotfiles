#!/bin/bash

readonly command=$1
readonly maxDisplayNumber=$2

readonly COLOR_OFF="%{F$(grep -P '^secondary' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_OFF="󰪑"
readonly COLOR_ON="%{F$(grep -P '^main' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_ON="󰂜"

function show_icon {
  if [ $(dunstctl is-paused) = true ]
    then
        echo $COLOR_OFF$ICON_OFF
    else
        echo $COLOR_ON$ICON_ON 
    fi
}

function display_history {
    history=$(dunstctl history)
    
    if [ "$maxDisplayNumber" != "" ] ; then
        maxNumber=$maxDisplayNumber
    else
        maxNumber=$(echo $history | jq .'data[0] | length')
    fi
    
    for (( i=0; i< $maxNumber; i++ ))
    do
        id=$(echo $history | jq ."data[0][$i].id.data")
        dunstctl history-pop $id
    done
}

case $command in

  "show")
    show_icon
  ;;

  "display-history")
    display_history $maxDisplayNumber
  ;;

esac

