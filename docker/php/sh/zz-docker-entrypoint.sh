#!/bin/sh
set -e

/usr/local/bin/fix-folder-file-permissions.sh
# Run composer install as www-data
su www-data -s /usr/local/bin/composer-install.sh

#/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
exec docker-php-entrypoint "$@"
