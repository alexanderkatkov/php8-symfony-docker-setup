FROM php:8.1-fpm-alpine as app

ENV APP_PATH=/var/www/app
ENV COMPOSER_PATH=/.composer/
ENV PHPINI_PATH=/usr/local/etc/php/php.ini
ENV COMPOSER_INSTALL_MODE="--no-dev --classmap-authoritative"

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
    acl \
    bash \
    fcgi \
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
    opcache \
    pcov \
    zip

# Composer install -------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy main config file -------------------
RUN cp /usr/local/etc/php/php.ini-production ${PHPINI_PATH}

# PHP copying application production config file -------------------
COPY ./docker/php/ini/30-symfony.prod.ini /usr/local/etc/php/conf.d/
# PHP-FPM copying additional config file -------------------
COPY ./docker/php/php-fpm/zz-docker.conf /usr/local/etc/php-fpm.d/

# Create and fix permissions to allow composer having cache -------------------
RUN mkdir ${COMPOSER_PATH}
RUN chown -R www-data:www-data $COMPOSER_PATH

# Set up project folder -------------------
COPY --chown=www-data . $APP_PATH
WORKDIR $APP_PATH

# Copy entrypoint & scripts -------------------
COPY ./docker/php/sh/fix-folder-file-permissions.sh /usr/local/bin/fix-folder-file-permissions.sh
COPY ./docker/php/sh/composer-install.sh /usr/local/bin/composer-install.sh
COPY ./docker/php/sh/docker-healthcheck.sh /usr/local/bin/docker-healthcheck.sh
COPY ./docker/php/sh/zz-docker-entrypoint.sh /docker-entrypoint.d/zz-docker-entrypoint.sh
RUN chmod -R a+x /usr/local/bin/fix-folder-file-permissions.sh
RUN chmod -R a+x /usr/local/bin/composer-install.sh
RUN chmod -R a+x /usr/local/bin/docker-healthcheck.sh
RUN chmod -R a+x /docker-entrypoint.d/zz-docker-entrypoint.sh

COPY ./docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Healthcheck -------------------
HEALTHCHECK --interval=1m --timeout=3s --retries=3 --start-period=30s CMD ["docker-healthcheck.sh"]

ENTRYPOINT /docker-entrypoint.d/zz-docker-entrypoint.sh

FROM app as app_dev

ENV USER_ID=1000
ENV GROUP_ID=1000
ENV COMPOSER_INSTALL_MODE=""

# DEV config for DEV environment -------------------
RUN cp /usr/local/etc/php/php.ini-development ${PHPINI_PATH}

# Xdebug installation -------------------
RUN install-php-extensions xdebug-^3.1

# Set FPM Child Process User ID -------------------
RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

# PHP copying application development config file, which will override production file values -------------------
COPY ./docker/php/ini/40-symfony.dev.ini /usr/local/etc/php/conf.d/

# Allow www-data to login via bash (for sudoing under www-data user for script executions) -------------------
RUN sed -E -i "s/(www-data.*)\/usr\/sbin\/nologin/\1\/bin\/bash/" /etc/passwd
