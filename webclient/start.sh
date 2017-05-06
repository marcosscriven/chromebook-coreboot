#! /bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WEBCLIENT_DIR=$SCRIPT_DIR/../out/webclient

if [ -f $WEBCLIENT_DIR/server.pid ]; then
  pid=$(cat $WEBCLIENT_DIR/server.pid)
  echo "Already started:${pid}"
  exit 0
fi

# Link source if necessary
if [ ! -f $WEBCLIENT_DIR/client.html ]; then
  ln -s $SCRIPT_DIR/client.html $WEBCLIENT_DIR
  ln -s $SCRIPT_DIR/client.js $WEBCLIENT_DIR
  ln -s $SCRIPT_DIR/worker.js $WEBCLIENT_DIR
fi

pushd $WEBCLIENT_DIR
python -m SimpleHTTPServer 8080 > /dev/null 2>&1 &
echo $! > $WEBCLIENT_DIR/server.pid
