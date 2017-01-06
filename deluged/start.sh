SALT=`cat Saltfile`
if [ -z $SALT ]; then
	SALT=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32} > Saltfile`
	SALT=`cat Saltfile`
fi
HASHED_PASSWD=`echo -n "$SALT$PASSWD" | sha1sum | awk '{ print $1}'`

cat core.conf | jq "if has(\"pwd_sha1\") then .pwd_sha1=\"$HASHED_PASSWD\" else . end"
