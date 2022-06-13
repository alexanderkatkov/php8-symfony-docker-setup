FROM nginx:stable-alpine

ENV ROOT_DIR=/var/www/app
ENV LOGS_DIR=${ROOT_DIR}/var/log/nginx

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
    logrotate

# Copy config -------------------
COPY ./docker/nginx/nginx.conf /etc/nginx/

# Copy logrotate config -------------------
COPY ./docker/nginx/logrotate /etc/logrotate.d/nginx

COPY ./public "${ROOT_DIR}/public/"
WORKDIR "${ROOT_DIR}/public/"
