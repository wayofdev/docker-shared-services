#!/usr/bin/env bash

if [ ! -f .env ]
then
    echo "[Warning] .env file not found. Please generate it using make env command!"
    exit 1;
else
    set -a
    source <(cat .env | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
    set +a
    TLS_DOMAINS=${TLS_DOMAINS%\"}
    echo "[Info] Domains to load:"
    for DOMAIN in ${TLS_DOMAINS#\"}; do
        echo " - ${DOMAIN}"
    done
fi

mkcert -key-file traefik/certs/key.pem -cert-file traefik/certs/cert.pem ${TLS_DOMAINS#\"}
