#!/bin/sh

set -e

echo 'Running...'

# Xdebug install for DEV environment -------------------
if [ "$APP_ENV" = "dev" ] ; then install-php-extensions xdebug; else echo 'Xdebug disabled'; fi

# Copy main config file -------------------
MAIN_PHP_INI_CONF_FOLDER_PATH="/usr/local/etc/php/php.ini";
if [ "$APP_ENV" = "dev" ] ; \
then \
  cp /usr/local/etc/php/php.ini-development "$MAIN_PHP_INI_CONF_FOLDER_PATH" ; \
else \
  cp /usr/local/etc/php/php.ini-production "$MAIN_PHP_INI_CONF_FOLDER_PATH" ; \
fi

# Copy project specific PHP config files
cp "${CONF_TMP_FOLDER}30-symfony.ini" /usr/local/etc/php/conf.d/

# PHP configs files folder
CONF_FOLDER_PATH="/usr/local/etc/php/conf.d/";

# Copy PHP config files depending on ENV
if [ "$APP_ENV" = "dev" ] ; \
then \
    cp  "${CONF_TMP_FOLDER}30-xdebug.ini" "$CONF_FOLDER_PATH"
fi

CONFIG_FILE_FOR_ENV="${CONF_TMP_FOLDER}40-${APP_ENV}.ini";
if [ -f "$CONFIG_FILE_FOR_ENV" ] ; \
then \
    cp  "$CONFIG_FILE_FOR_ENV" "$CONF_FOLDER_PATH"
fi
