#! /bin/bash

readonly CMD=$1

function set_dict {
  bar="▁▂▃▄▅▆▇█"
  dict="s/;//g;"

  i=0
  while [ $i -lt ${#bar} ]
  do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
  done
  echo $dict
}

function write_config {
  config_file="/tmp/polybar_cava_mic_config"
  echo "
  [general]
  bars = 2

  [input]
  method = pulse
  source = $(pacmd list-sources | grep '* index' | awk '{print $3}')

  [output]
  method = raw
  raw_target = /dev/stdout
  data_format = ascii
  ascii_max_range = 7
  " > $config_file

  echo $config_file
}

function show_bars {
  dict=$(set_dict)
  config_file=$(write_config)
  cava -p $config_file | while read -r line; do
    echo $line | sed $dict
  done
}

case $CMD in
  "--show")
    show_bars
  ;;

  *)
    echo "Invalid command"
    echo ""
    echo "Available commands:"
    echo "--show                     Show cava bars"
    exit 0
  ;;
esac
