#!/bin/bash

readonly CMD=$1

readonly GAME_ICON="󰸼"

readonly DEFAULT_ICON="󰀄"

function show_icon {
    if [ $(cat $HOME/.config/sxhkd/current_profile) = $HOME/.config/sxhkd/profiles/defaultrc ]
    then
      echo $DEFAULT_ICON
    elif [ $(cat $HOME/.config/sxhkd/current_profile) = $HOME/.config/sxhkd/profiles/gamerc ]
    then
      echo $GAME_ICON
    fi
}

function toggle_profile {
    killall sxhkd

    dunstify --appname="sxhkd" "SXHKD profile switched!"

    if [ $(cat $HOME/.config/sxhkd/current_profile) = $HOME/.config/sxhkd/profiles/defaultrc ]
    then
        echo $HOME/.config/sxhkd/profiles/gamerc > $HOME/.config/sxhkd/current_profile
        sxhkd -c $HOME/.config/sxhkd/profiles/gamerc &
    elif [ $(cat $HOME/.config/sxhkd/current_profile) = $HOME/.config/sxhkd/profiles/gamerc ]
    then
        echo $HOME/.config/sxhkd/profiles/defaultrc > $HOME/.config/sxhkd/current_profile
        sxhkd -c $HOME/.config/sxhkd/profiles/defaultrc &
    fi

}

case $CMD in
    
    "--show")
        show_icon
    ;;
    
    "--toggle")
        toggle_profile
    ;;
    
    *)
        echo "Invalid command"
        echo ""
        echo "Available commands :"
        echo "--toggle                   Toggle profiles"
        echo "--show                     Show icons"
        exit 0
    ;;

esac
