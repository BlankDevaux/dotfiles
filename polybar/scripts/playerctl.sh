#!/bin/bash

readonly CMD=$1

# The name of polybar bar which houses the main spotify module and the control modules.
PARENT_BAR="now-playing"
PARENT_BAR_PID=$(pgrep -a "polybar" | grep "$PARENT_BAR" | cut -d" " -f1)

# Set the source audio player here.
# Players supporting the MPRIS spec are supported.
# Examples: spotify, vlc, chrome, mpv and others.
# Use `playerctld` to always detect the latest player.
# See more here: https://github.com/altdesktop/playerctl/#selecting-players-to-control
PLAYER="spotify"

# Format of the information displayed
# Eg. {{ artist }} - {{ album }} - {{ title }}
# See more attributes here: https://github.com/altdesktop/playerctl/#printing-properties-and-metadata
FORMAT="{{ title }} - {{ artist }}"

# Sends $2 as message to all polybar PIDs that are part of $1
function update_hooks {
  while IFS= read -r id
  do
    polybar-msg -p "$id" hook spotify-play-pause $2 1>/dev/null 2>&1
  done < <(echo "$1")
}

function get_status {
  PLAYERCTL_STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)
  EXIT_CODE=$?
  if [ "$EXIT_CODE" -eq 0 ]; then
    STATUS=$PLAYERCTL_STATUS
  else
    STATUS="No player is running"
  fi
  echo $STATUS
}

function display_status {
  STATUS=$(get_status)
  if [ "$1" == "--status" ]; then
    echo "$STATUS"
  else
    if [ "$STATUS" = "Stopped" ]; then
      echo "No music is playing"
    elif [ "$STATUS" = "Paused"  ]; then
      update_hooks "$PARENT_BAR_PID" 2
      playerctl --player=$PLAYER metadata --format "$FORMAT"
    elif [ "$STATUS" = "No player is running"  ]; then
      echo ""
    else
      update_hooks "$PARENT_BAR_PID" 1
      playerctl --player=$PLAYER metadata --format "$FORMAT"
    fi
  fi
}

function display_position {
  STATUS=$(get_status)
  if [ "$STATUS" = "No player is running"  ]
  then
    echo ""
  else
    TRACK_LENGTH=$(playerctl metadata mpris:length)
    TRACK_POSITION=$(playerctl position)
    echo "$TRACK_POSITION %"
    # "█▉▊▋▌▍▎▏"
    # echo "[██████████]"
  fi
}

function scroll_now_playing {
  zscroll -l 32 \
    --delay 0.1 \
    --scroll-padding "  " \
    --match-command "`dirname $0`/playerctl.sh --status" \
    --match-text "Playing" "--scroll 1" \
    --match-text "Paused" "--scroll 0" \
    --update-check true "`dirname $0`/playerctl.sh" &
  wait
}

case $CMD in
    "--scroll")
      scroll_now_playing
    ;;
    
    "--status")
      get_status
    ;;
    
    "--position")
      display_position
    ;;

    *)
      display_status
    ;;
esac
