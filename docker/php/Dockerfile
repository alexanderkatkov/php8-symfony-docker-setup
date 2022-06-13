FROM php:8.1-fpm-alpine

ENV APP_PATH=/var/www/app
ENV APP_ENV=${ENV:-dev}
ENV CONF_TMP_FOLDER="/var/tmp/php-configs/"

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
  acl \
  bash \
  git \
  openssh \
  supervisor \
  wget \
  zip

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

RUN install-php-extensions \
    bcmath \
    http \
    pcov \
    intl \
    pdo_pgsql

# Composer install -------------------
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy PHP config files to storage folder
RUN mkdir -p "$CONF_TMP_FOLDER"
COPY ./docker/php/ini/*.ini "$CONF_TMP_FOLDER"

# Set up project folder -------------------
COPY . $APP_PATH
WORKDIR $APP_PATH

# Create /var folder -------------------
RUN mkdir -p "$APP_PATH/var/log"

# Symfony folders permission fix
RUN HTTPDUSER=$(ps axo user,comm | grep -E "[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx" | grep -v root | head -1 | cut -d\  -f1)
RUN setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX $APP_PATH
RUN setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX $APP_PATH

# Create and fix permissions to allow composer having cache -------------------
RUN mkdir /.composer/
RUN chown -R www-data:www-data /.composer/

COPY ./docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY ./docker/php/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD /bin/sh -c /usr/local/bin/entrypoint.sh

ENTRYPOINT /bin/sh -c /usr/local/bin/entrypoint.sh && \
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
