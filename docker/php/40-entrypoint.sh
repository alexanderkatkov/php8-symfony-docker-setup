#!/bin/sh
set -e

setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX ${APP_PATH}/var
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX ${APP_PATH}/var

exec docker-php-entrypoint "$@"
