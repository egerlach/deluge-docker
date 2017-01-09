#!/bin/bash

CONFIG=/var/lib/deluged/config/
SALT=`cat $CONFIG/Saltfile`
if [ -z $SALT ]; then
  SALT=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > $CONFIG/Saltfile`
  SALT=`cat $CONFIG/Saltfile`
fi

if [ ! -f $CONFIG/core.conf ]; then
  cp /core.conf $CONFIG
fi

if [ ! -z "$TORRENT_PORT" ]; then
  cat $CONFIG/core.conf | \
    jq "if has(\"random_port\") then .random_port=false else . end" | \
    jq "if has(\"listen_ports\") then .listen_ports=[$TORRENT_PORT,$TORRENT_PORT] else . end" | \
    sponge $CONFIG/core.conf
fi

HASHED_PASSWD=`echo -n "$SALT$PASSWD" | sha1sum | awk '{ print $1 }'`

cat $CONFIG/core.conf | \
  jq "if has(\"pwd_sha1\") then .pwd_sha1=\"$HASHED_PASSWD\" else . end" | \
  sponge $CONFIG/core.conf

/usr/bin/deluged -d -c$CONFIG "$@"
