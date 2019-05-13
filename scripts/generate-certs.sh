#!/bin/sh

# Generate cert for anything using https://dockerlocal
# i.e. Portainer/Rancher2/Concourse
cd /certs
[ ! -f cert.crt ] && openssl req -newkey rsa:2048 -x509 -nodes -new \
    -keyout key.pem \
    -out cert.crt \
    -subj /CN=dockerlocal \
    -reqexts SAN -extensions SAN \
    -config <(cat /etc/ssl/openssl.cnf \
        <(printf '[SAN]\nsubjectAltName=DNS:dockerlocal'))
[ ! -f cacerts.crt ] && cp cert.crt cacerts.crt

# Generate keys for Concourse CI
cd /concourse
[ ! -f session_signing_key ] && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out session_signing_key
[ ! -f tsa_host_key ] && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out tsa_host_key
[ ! -f worker_key ] && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out worker_key

[ ! -f tsa_host_key.pub ] && openssl rsa -in tsa_host_key -pubout -out tsa_host_key.pub
[ ! -f worker_key.pub ] && openssl rsa -in worker_key -pubout -out worker_key.pub

cp worker_key.pub authorized_worker_keys
