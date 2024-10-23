#!/bin/bash

readonly CMD=$1

readonly WORK_TIME=25
readonly BREAK_TIME=5

function run() {
  start="$(( $(date +%s) + (25 * 60)))"
  
  while [ $start -ge $(date +%s) ]
  do
    time="$(( $start - $(date +%s) ))"
    echo "$(date -u -d "@$time" +%H:%M:%S)"
    sleep 0.1
  done
}

# function start() {
#
# }
#
# function reset() {
#   
# }

case $CMD in
  "--run")
    run
  ;;
  
  "--start")
    start
  ;;

  "--reset")
    reset
  ;;
    
  *)
    echo "Invalid command"
    echo ""
    echo "Available commands :"
    echo "--run                       Run the pomodoro timer"
    echo "--start                     Start the timer"
    echo "--reset                     Reset the timer"
    exit 0
  ;;
esac
