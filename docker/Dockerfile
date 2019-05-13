FROM docker:dind

# Install docker-compose, see https://wiki.alpinelinux.org/wiki/Docker
RUN apk --update --no-cache add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make
RUN pip install docker-compose

# Additional utilities
RUN apk --update --no-cache add apache2-utils bash openssl

CMD ["/bin/bash"]
