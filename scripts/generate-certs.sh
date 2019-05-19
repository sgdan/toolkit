#!/bin/bash

# Generate cert for anything using https://dockerlocal
# i.e. Portainer/Rancher2/Concourse
cd /certs
[ ! -f cert.crt ] && openssl req -newkey rsa:2048 -x509 -nodes -new \
    -keyout key.pem \
    -out cert.pem \
    -subj /CN=dockerlocal \
    -reqexts SAN -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:dockerlocal'))
[ ! -f cacerts.pem ] && cp cert.pem cacerts.pem
chmod a+r *
