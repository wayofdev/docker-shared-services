#!/usr/bin/env bash

# Function to check if mkcert is installed
check_mkcert_installed() {
    if ! command -v mkcert &> /dev/null; then
        echo "[Error] mkcert is not installed. Please install mkcert first."
        exit 1
    fi
}

# Function to install mkcert CA
install_mkcert_ca() {
    echo "[Info] Installing mkcert CA..."
    mkcert -install
}

# Function to load environment variables from .env file
load_env() {
    if [ ! -f .env ]; then
        echo "[Warning] .env file not found. Please generate it using make env command!"
        exit 1
    else
        set -a
        # shellcheck disable=SC2002
        source <(cat .env | sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
        set +a
    fi
}

# Function to display domains to be loaded
display_domains() {
    local DOMAINS
    local DOMAIN

    DOMAINS=$(echo "$TLS_DOMAINS" | sed -e 's/^"//' -e 's/"$//')

    echo "[Info] Domains to load:"
    for DOMAIN in $DOMAINS; do
        echo " - ${DOMAIN}"
    done
}

# Function to generate certificates
generate_certs() {
    local DOMAINS
    DOMAINS=$(echo "$TLS_DOMAINS" | sed -e 's/^"//' -e 's/"$//')
    # shellcheck disable=SC2086
    mkcert -key-file traefik/certs/key.pem -cert-file traefik/certs/cert.pem $DOMAINS
}

# Main script execution
main() {
    check_mkcert_installed
    install_mkcert_ca
    load_env
    display_domains
    generate_certs
}

main
