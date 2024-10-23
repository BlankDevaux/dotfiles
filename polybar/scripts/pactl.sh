#!/bin/bash

readonly CMD=$1

DEFAULT_SINK=$(pactl info | grep "Default Sink:" | cut -d':' -f2)

function check_current_volume {
    CURRENT_VOLUME=$(pactl get-sink-volume $DEFAULT_SINK | grep "Volume:" | cut -d'/' -f2 | sed -E 's/ |%//g')
    echo $CURRENT_VOLUME
}

function raise_volume {
    if [ $(($(check_current_volume))) -ge 100 ]; then exit 0 ; fi
    if [ $(($(check_current_volume) % 2 )) -eq 0 ]
    then
        pactl set-sink-volume $DEFAULT_SINK +2%
    else
        pactl set-sink-volume $DEFAULT_SINK +1%
    fi
}

function lower_volume {
    if [ $(($(check_current_volume) % 2 )) -eq 0 ]
    then
        pactl set-sink-volume $DEFAULT_SINK -2%
    else
        pactl set-sink-volume $DEFAULT_SINK -1%
    fi
}

function mute_volume {
    pactl set-sink-mute $DEFAULT_SINK toggle
}

case $CMD in
    "--raise")
      raise_volume
    ;;
    
    "--lower")
      lower_volume
    ;;
    
    "--mute")
      mute_volume
    ;;

    *)
      echo "Invalid command"
      echo ""
      echo "Available commands :"
      echo "--raise                     Raise the volume"
      echo "--lower                     Lower the volume"
      echo "--mute                     Mute audio"
      exit 0
    ;;
esac
