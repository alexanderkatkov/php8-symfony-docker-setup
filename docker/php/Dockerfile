FROM php:8.1-fpm-alpine as app

ENV APP_PATH=/var/www/app
ENV COMPOSER_PATH=/.composer/
ENV PHPINI_PATH=/usr/local/etc/php/php.ini

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
  acl \
  bash \
  git \
  openssh \
  shadow \
  supervisor \
  wget \
  zip

# Install PHP extensions -------------------
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions \
    bcmath \
    http \
    intl \
    pcov \
    zip

# Composer install -------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy main config file -------------------
RUN cp /usr/local/etc/php/php.ini-production ${PHPINI_PATH}

# PHP copying additional configs files -------------------
COPY ./docker/php/ini/*.ini ./docker/php/ini/40-${APP_ENV}.ini* /usr/local/etc/php/conf.d/

# Create /var/log folder -------------------
RUN mkdir -p "${APP_PATH}/var/log"
RUN mkdir -p "${APP_PATH}/var/cache"

# Create and fix permissions to allow composer having cache -------------------
RUN mkdir ${COMPOSER_PATH}
RUN chown -R www-data:www-data $COMPOSER_PATH

# Set up project folder -------------------
COPY --chown=www-data . $APP_PATH
WORKDIR $APP_PATH

# Copy entrypoint -------------------
COPY ./docker/php/40-entrypoint.sh /docker-entrypoint.d/40-entrypoint.sh
RUN chmod a+x /docker-entrypoint.d/40-entrypoint.sh

COPY ./docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

FROM app as app_dev

ENV USER_ID=1000
ENV GROUP_ID=1000

# DEV config for DEV environment -------------------
RUN cp /usr/local/etc/php/php.ini-development ${PHPINI_PATH}

# Xdebug install for DEV environment -------------------
RUN install-php-extensions xdebug-^3.1

# Set FPM Child Process User ID -------------------
RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data
# Allow www-data to login bia bash (for sudoing into www-data for script executions) -------------------
RUN sed -E -i "s/(www-data.*)\/usr\/sbin\/nologin/\1\/bin\/bash/" /etc/passwd
