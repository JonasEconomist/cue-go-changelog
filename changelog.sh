#!/bin/sh
if [ -z "$DAEMON_HOME" ]; then
  DAEMON_HOME=$( cd "$( dirname "$0" )" && pwd )
fi
if [ "$1" != "" ]; then
 cd $1 || exit $?
fi
java -jar $DAEMON_HOME/changelog.jar
