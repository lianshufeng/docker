#!/bin/bash





if [ ! -z "$RUN_CMD" ]; then
  echo run cmd
  sh /boot/run_cmd.sh 
fi


if [ ! -z "$CHROME_CMD" ]; then
  echo run chrome
  sh /boot/chrome_cmd.sh 
fi