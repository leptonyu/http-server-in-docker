#!/bin/sh
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done

ROOT=`dirname "$PRG"`
ROOT=`cd "$ROOT";pwd`

cd "$ROOT"

LABEL=icymint/http
TEMP_LABEL=icymint-http-builder

TID=`docker images -q $TEMP_LABEL`

if [ -n "$TID" ]; then
  echo "$TID exists!"
  exit 1
fi

ID=`docker images -q $LABEL`

if [ -n "$ID" ]; then
  docker rmi -f "$ID"
fi

GO=`docker images -q golang:alpine`

docker build --rm --no-cache -t $TEMP_LABEL . \
&& docker run --rm $TEMP_LABEL | docker build --rm --no-cache -t $LABEL - \
&& docker rmi $TEMP_LABEL

if [ -z "$GO" ]; then
  docker rmi -f golang:alpine
fi
