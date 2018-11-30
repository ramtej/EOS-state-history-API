#!/bin/bash
###########################################################################
# Startup script based on http://CryptoLions.io
###########################################################################

if [ -f $(pwd)"/statehistoryapi.pid" ]; then
  pid=`cat $(pwd)"/statehistoryapi.pid"`
  echo $pid
  kill $pid
  rm -r $(pwd)"/statehistoryapi.pid"

  echo -ne "Stoping State History API"

  while true; do
    [ ! -d "/proc/$pid/fd" ] && break
    echo -ne "."
    sleep 1
  done
  echo -ne "\rState History API Stopped.    \n"
fi
