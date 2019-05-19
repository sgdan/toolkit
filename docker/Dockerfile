FROM docker:18.09

# Install docker-compose, see https://wiki.alpinelinux.org/wiki/Docker
RUN apk --update --no-cache add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install docker-compose

# Additional utilities
RUN apk --update --no-cache add \
    bash curl \
    \
    # for generating certs
    openssl \
    \
    # has htpasswd utility for encrypting portainer password
    apache2-utils \
    \
    # for stripping out elements from JSON e.g. parsing Rancher REST responses 
    jq

CMD ["/bin/bash"]
