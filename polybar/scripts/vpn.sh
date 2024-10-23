#!/bin/bash

readonly CMD=$1

readonly VPN_PATH=~/Documents/scripts/.vpn
readonly COLOR_OFF="%{F$(grep -P '^secondary' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_OFF=""
readonly COLOR_ON="%{F$(grep -P '^main' ~/.config/polybar/colors.ini | awk '{print $3}')}"
readonly ICON_ON=""

function show_icon {
  VPN_STATUS=$(forticlient vpn status | grep Status | awk '{print $NF}')
  
  if [ "$VPN_STATUS" = 'Connected' ]
  then
    echo $COLOR_ON$ICON_ON
  else
    echo $COLOR_OFF$ICON_OFF
  fi
}

function toggle {
  forticlient_id=$(xdo id -N FortiClient | sed -n '1 p')

  if [ -z $forticlient_id ] ; then 
    forticlient gui    
  else
    bspc node $forticlient_id -c
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
    echo "--toggle                   Toggle vpn on/off"
    echo "--show                     Show icons"
    exit 0
  ;;
esac
