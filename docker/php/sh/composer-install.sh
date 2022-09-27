#!/bin/sh
set -e

if [[ -f "${APP_PATH}/composer.json" ]]; then
  composer install ${COMPOSER_INSTALL_MODE}
fi
