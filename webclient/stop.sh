#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WEBCLIENT_DIR=$SCRIPT_DIR/../out/webclient

if [ ! -f $WEBCLIENT_DIR/server.pid ]; then
  echo "Already stopped."
  exit 0
fi

pid=$(cat $WEBCLIENT_DIR/server.pid)
kill -9 $pid
rm $WEBCLIENT_DIR/server.pid
