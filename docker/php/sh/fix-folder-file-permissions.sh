#!/bin/sh
set -e

if [ -d "${APP_PATH}/var" ]; then
    setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX "${APP_PATH}/var"
    setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX "${APP_PATH}/var"
fi
