FROM php:8.1-fpm-alpine

ENV APP_PATH=/var/www/app
ARG APP_ENV=${APP_ENV:-dev}

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
  acl \
  bash \
  git \
  openssh \
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

# Xdebug install for DEV environment -------------------
RUN if [ "$APP_ENV" = "dev" ] ; then install-php-extensions xdebug; else echo 'Xdebug disabled'; fi

# Composer install -------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy main config file -------------------
RUN if [ "$APP_ENV" = "dev" ] ; \
then \
  cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini ; \
else \
  cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini ; \
fi

# PHP copying additional configs files -------------------
COPY ./docker/php/ini/*.ini ./docker/php/ini/40-${APP_ENV}.ini* /usr/local/etc/php/conf.d/

# Set up project folder -------------------
COPY . $APP_PATH
WORKDIR $APP_PATH

# Create /var/log folder -------------------
RUN mkdir -p "${APP_PATH}/var/log"
RUN mkdir -p "${APP_PATH}/var/cache"

# Symfony folders permission fix
RUN setfacl -dR -m u:www-data:rwX -m u:$(whoami):rwX $APP_PATH
RUN setfacl -R -m u:www-data:rwX -m u:$(whoami):rwX $APP_PATH

# Create and fix permissions to allow composer having cache -------------------
RUN mkdir /.composer/
RUN chown -R www-data:www-data /.composer/

COPY ./docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

WORKDIR $APP_PATH
