FROM paulczar/omgwtfssl AS certgen
RUN SILENT=true SSL_EXPIRE=365 SSL_SUBJECT=echo-server.dev SSL_KEY=/tmp/key.pem SSL_CERT=/tmp/cert.pem /usr/local/bin/generate-certs

FROM openresty/openresty:alpine

LABEL maintainer="Srinath Sankar <srinath@iambot.net>"
LABEL version="0.1"

EXPOSE 80 443

COPY --from=certgen /tmp/*.pem /etc/ssl/selfsigned/
COPY ./lib /app/lib
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
