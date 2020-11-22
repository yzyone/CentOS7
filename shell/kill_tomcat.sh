#!/bin/sh

PID="`/usr/bin/pgrep -f 'tomcat'`"
EXECUTABLE=bin/catalina.sh

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`


if [ ! -x "$PRGDIR"/"$EXECUTABLE" ]; then
    echo "Cannot find $PRGDIR/$EXECUTABLE"
    echo "The file is absent or does not have execute permission"
    echo "This file is needed to run this program"
    exit 1
fi

if [ -n "$PID" ]
then
  echo "Tomcat [PID] $PID running..."
  # kill all tomcat
  ps -ef|grep tomcat|grep -v grep|awk '{print $2}'|xargs kill -9
  echo "Tomcat [PID] $PID killed."
else
  echo "Tomcat not exists."
fi
