#!/bin/bash
###########################################################################
# Startup script based on http://CryptoLions.io
###########################################################################

mkdir -p logs

./stop.sh
node index.js &> $(pwd)/logs/$(date +%Y-%m-%d_%H-%M-%S.log) & echo $! > $(pwd)/statehistoryapi.pid
