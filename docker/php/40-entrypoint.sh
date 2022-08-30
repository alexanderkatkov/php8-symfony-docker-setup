#!/bin/sh
set -e

setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var

exec docker-php-entrypoint "$@"
