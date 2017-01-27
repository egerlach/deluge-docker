#!/bin/bash

CONFIG=/var/lib/deluged/web-config

if [ ! -f $CONFIG/core.conf ]; then
  cp /core.conf $CONFIG
fi

if [ ! -f $CONFIG/web.conf ]; then
  cp /web.conf $CONFIG
fi

if [ ! -f $CONFIG/hostlist.conf.1.2 ]; then
  cp /hostlist.conf.1.2 $CONFIG
fi

SALT=`cat $CONFIG/Saltfile`
if [ -z $SALT ]; then
  SALT=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32 > $CONFIG/Saltfile`
  SALT=`cat $CONFIG/Saltfile`
fi

HASHED_PASSWD=`echo -n "$SALT$PASSWD" | sha1sum | awk '{ print $1 }'`

cat $CONFIG/web.conf | \
  jq "if has(\"pwd_sha1\") then .pwd_sha1=\"$HASHED_PASSWD\" else . end" | \
  jq "if has(\"pwd_salt\") then .pwd_salt=\"$SALT\" else . end" | \
  sponge $CONFIG/web.conf

cat $CONFIG/hostlist.conf.1.2 | \
  jq "if has(\"hosts\") then .hosts=[.hosts[] | if .[0]==\"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\" then [.[0,1,2,3], \"$SHARED_SECRET\"] else . end] else . end" | \
  sponge $CONFIG/hostlist.conf.1.2

/usr/bin/deluge-web -c$CONFIG "$@"
