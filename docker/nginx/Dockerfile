FROM nginx:stable-alpine

ENV ROOT_DIR=/var/www/app
ENV LOGS_DIR=${ROOT_DIR}/var/log/nginx

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
    logrotate \
    openssl

# Create selfsigned SSL certificate -------------------
RUN openssl req -x509 -nodes -days 365 -subj "/C=CA/ST=QC/O=Company,  \
    Inc./CN=mydomain.com" -addext "subjectAltName=DNS:mydomain.com"  \
    -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key  \
    -out /etc/ssl/certs/nginx-selfsigned.crt;

# Copy config -------------------
COPY ./docker/nginx/nginx.conf /etc/nginx/

# Copy logrotate config -------------------
COPY ./docker/nginx/logrotate /etc/logrotate.d/nginx

COPY ./public "${ROOT_DIR}/public/"

WORKDIR "${ROOT_DIR}/public/"
