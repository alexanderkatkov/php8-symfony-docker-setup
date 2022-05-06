ARG NGINX_VERSION=${NGINX_VERSION:-nginx:mainline-alpine}

FROM $NGINX_VERSION

ARG APP_DIR

COPY docker/nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY public "/var/www/${APP_DIR}/public/"
