FROM php:8-fpm-alpine

# Arguments -------------------
ARG ENABLE_XDEBUG=${APP_ENABLE_XDEBUG}

# ENV vars -------------------
ENV WAIT_VERSION 2.7.2
ENV USER=${APP_USERNAME}
ENV HOME_DIR=/home/$USER
ENV COMPOSER_HOME=$HOME_DIR/.composer

# Additional packages installing -------------------
RUN apk add wget bash git openssh

# Add docker-compose-wait tool -------------------
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Composer install -------------------
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php --quiet

WORKDIR /var/www/${APP_WORKDIR}

