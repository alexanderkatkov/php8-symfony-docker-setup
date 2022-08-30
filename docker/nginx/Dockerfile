FROM nginx:stable-alpine as nginx

ENV ROOT_DIR=/var/www/app
ENV LOGS_DIR=${ROOT_DIR}/var/log/nginx

# Additional packages installing -------------------
RUN apk update && apk add --no-cache \
    acl \
    openssl

# Copy config -------------------
COPY ./docker/nginx/nginx.conf /etc/nginx/

# Set up project folder -------------------
RUN mkdir -p ${LOGS_DIR}
COPY --chown=nginx ./public "${ROOT_DIR}/public/"
WORKDIR "${ROOT_DIR}/public/"

FROM nginx as nginx_dev

# Create selfsigned SSL certificate -------------------
RUN openssl req -x509 -nodes -days 365  \
    -subj "/C=CA/ST=QC/O=Company, Inc./CN=mydomain.local"  \
    -addext "subjectAltName=DNS:mydomain.local"  \
    -newkey rsa:2048 -keyout /etc/ssl/private/nginx-ssl.key  \
    -out /etc/ssl/certs/nginx-ssl.crt;
