#!/bin/bash

CONFIG=/var/lib/deluged/config

for d in "$DIRS"; do
  mkdir -p /srv/$d
done

chown $DELUGE_USER_ID:$DELUGE_GROUP_ID /var/lib/deluged /var/lib/deluged/config

GOSU="/usr/local/bin/gosu $DELUGE_USER_ID:$DELUGE_GROUP_ID"

if [ ! -f $CONFIG/core.conf ]; then
  cp /core.conf $CONFIG
fi

if [ ! -z "$TORRENT_PORT" ]; then
  cat $CONFIG/core.conf | \
    jq "if has(\"random_port\") then .random_port=false else . end" | \
    jq "if has(\"listen_ports\") then .listen_ports=[$TORRENT_PORT,$TORRENT_PORT] else . end" | \
    $GOSU sponge $CONFIG/core.conf
fi

if ! grep -q "docker:$SHARED_SECRET" $CONFIG/auth; then
  $GOSU /bin/bash -c "echo \"docker:$SHARED_SECRET:10\" >> $CONFIG/auth"
fi

$GOSU /usr/bin/deluged -d -c$CONFIG "$@"
