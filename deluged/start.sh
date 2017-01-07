#!/bin/bash

CONFIG=/var/lib/deluged/config/
SALT=`cat $CONFIG/Saltfile`
if [ -z $SALT ]; then
  SALT=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > $CONFIG/Saltfile`
  SALT=`cat $CONFIG/Saltfile`
fi

HASHED_PASSWD=`echo -n "$SALT$PASSWD" | sha1sum | awk '{ print $1}'`

$(cat $CONFIG/core.conf | \
  jq "if has(\"pwd_sha1\") then .pwd_sha1=\"$HASHED_PASSWD\" else . end" | \
  jq "if has(\"pwd_sha1\") then .pwd_sha1=\"$HASHED_PASSWD\" else . end") > $CONFIG/core.conf

/usr/bin/deluged -d -Ldebug -c$CONFIG
