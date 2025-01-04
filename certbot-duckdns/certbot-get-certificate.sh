#!/bin/bash

# see: https://github.com/infinityofspace/certbot_dns_duckdns?tab=readme-ov-file#credentials-file-or-cli-parameters

domain="domain.duckdns.org"

docker run \
    -v "./letsencrypt:/etc/letsencrypt" \
    -v "./letsencrypt-logs:/var/log/letsencrypt" \
    -v "./duckdns.ini:/conf/duckdns.ini" \
    infinityofspace/certbot_dns_duckdns:latest \
        certonly \
            --non-interactive \
            --agree-tos \
            --register-unsafely-without-email \
            --preferred-challenges dns \
            --authenticator dns-duckdns \
            --dns-duckdns-credentials /conf/duckdns.ini \
            --dns-duckdns-propagation-seconds 60 \
            -d "${domain}"
