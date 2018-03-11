#!/bin/bash
set -e

USER_ID=${LOCAL_USER_ID:-999}
GROUP_ID=${LOCAL_GROUP_ID:-999}

groupadd -r -g $GROUP_ID -o nginx || true
useradd -r -u $USER_ID -o -g nginx nginx || true

rm -rf /var/run/*

if [ "$1" = 'nginx' ]; then
	exec nginx -c "${NGX_CONFIG}"/nginx.conf
fi

exec "$@"
