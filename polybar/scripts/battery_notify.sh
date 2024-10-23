#!/bin/bash

BAT_STATUS=/tmp/battery_notify

if [ ! -f $BAT_STATUS ]
then
    touch $BAT_STATUS
    echo "no" > $BAT_STATUS
fi


LOW_BAT=20
ICON_PATH="/usr/share/icons/Tela-circle-black-dark/symbolic/status/battery-empty-symbolic.svg"
ALREADY_NOTIFY=$([ $(cat $BAT_STATUS) == "yes" ] && echo true || echo false)

BAT_PATH=/sys/class/power_supply/BAT0

BAT_LEVEL=$(cat "$BAT_PATH/capacity")

if [ $BAT_LEVEL -lt $LOW_BAT ]
then
    if [ $ALREADY_NOTIFY = false ]
    then
        echo "yes" > $BAT_STATUS
        dunstify --appname="battery" "Battery low" --urgency="critical" -i $ICON_PATH
        paplay $NOTIFICATION_SOUND
    fi
else
    if [ $ALREADY_NOTIFY = true ]
    then
        echo "no" > $BAT_STATUS
    fi
fi
