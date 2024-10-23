#!/bin/bash

BAR_HEIGHT=30  # polybar height
BORDER_SIZE=1  # border size from your wm settings
YAD_WIDTH=222  # 222 is minimum possible value
YAD_HEIGHT=193 # 193 is minimum possible value
DATE=$(LC_TIME="fr_FR.UTF-8" date +"%H:%M:%S")

case "$1" in
    *)
        echo "$DATE"
    ;;
esac
