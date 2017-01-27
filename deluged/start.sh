#!/bin/bash

CONFIG=/var/lib/deluged/config

if [ ! -f $CONFIG/core.conf ]; then
  cp /core.conf $CONFIG
fi

if [ ! -z "$TORRENT_PORT" ]; then
  cat $CONFIG/core.conf | \
    jq "if has(\"random_port\") then .random_port=false else . end" | \
    jq "if has(\"listen_ports\") then .listen_ports=[$TORRENT_PORT,$TORRENT_PORT] else . end" | \
    sponge $CONFIG/core.conf
fi

if ! grep -q "docker:$SHARED_SECRET" $CONFIG/auth; then
  echo "docker:$SHARED_SECRET:10" >> $CONFIG/auth
fi

/usr/bin/deluged -d -c$CONFIG "$@"
