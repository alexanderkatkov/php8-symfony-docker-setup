#!/bin/sh
set -e

/usr/local/bin/var-folder-file-permissions.sh

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

exec docker-php-entrypoint "$@"
