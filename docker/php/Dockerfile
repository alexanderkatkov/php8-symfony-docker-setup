ARG APP_PHP_VERSION=${APP_PHP_VERSION:-php:8-fpm-alpine}
FROM $APP_PHP_VERSION

ARG APP_DIR
ARG APP_ENV=${APP_ENV:-dev}
ARG APP_USERNAME
ARG GID=${GID}
ARG UID=${UID}
ARG WAIT_VERSION=${WAIT_VERSION:-2.7.2}
ENV APP_PATH=/var/www/$APP_DIR
ENV COMPOSER_HOME=$HOME_DIR/.composer
ENV HOME_DIR=/home/$APP_USERNAME

RUN  if [ "$APP_ENV" = "dev" ] ; \
then \
  cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini ; \
else \
  cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini ; \
fi

# Additional packages installing -------------------
RUN apk add wget bash git openssh

# Add docker-compose-wait tool -------------------
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
    bcmath \
    http \
    pcov \
    intl \
    pdo_pgsql

# Xdebug check and install -------------------
RUN  if [ "$APP_ENV" = "dev" ] ; then install-php-extensions xdebug; else echo 'Xdebug disabled'; fi

# Composer install -------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Add user and group -------------------
RUN addgroup -g $GID $APP_USERNAME \
    && adduser -u $UID -G $APP_USERNAME -s /bin/sh -D $APP_USERNAME

# Create and fix permissions to allow composer having cache -------------------
RUN mkdir "/.composer"
RUN chown -R $APP_USERNAME:$APP_USERNAME /.composer/

# Copy PHP config files
COPY docker/php/ini/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY docker/php/ini/symfony.ini /usr/local/etc/php/conf.d/symfony.ini

# Set up project folder -------------------
COPY . $APP_PATH
RUN chown -R $APP_USERNAME:$APP_USERNAME $APP_PATH
WORKDIR $APP_PATH

# Switch user to non root
USER $APP_USERNAME
