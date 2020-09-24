#!/bin/bash

PROXY_HOME="/home/proxy-admin/"

#PID="`/usr/bin/ps -eo pid,cmd | awk '{print $1,$2}' | grep '/proxy'`"
PID="`/usr/bin/pgrep -f '/proxy'`"

echo "[PID] $PID"

if [ -n "$PID" ]
then
  echo "[PID] $PID running..."
  kill -9 $PID
  echo "[PID] $PID killed."
else
  CMD="$PROXY_HOME/proxy socks -t tcp -p 0.0.0.0:52830 --daemon"
  echo "[CMD]='$CMD'"
  $CMD
fi