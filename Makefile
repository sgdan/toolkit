
.env:
	docker-compose build docker
	docker-compose run --rm docker cp env.example .env

.docker: docker/Dockerfile .env
	docker-compose build docker
	touch .docker

# Utility shell with access to project folder
shell: .docker
	docker-compose run --rm docker bash

# Generate certs and keys for portainer and concourse
.certs: .env .docker
	docker-compose run --rm docker bash ./scripts/generate-certs.sh
	touch .certs

portainer: .certs
	ENCRYPTED_PASSWORD=$$(docker-compose run --rm docker bash ./scripts/encrypt-admin-pass.sh) \
	docker-compose up -d portainer

portainer-stop:
	docker-compose stop portainer

concourse: .certs
	docker-compose up -d concourse-db concourse-web concourse-worker

concourse-stop:
	docker-compose stop concourse-db concourse-web concourse-worker

# start a bash shell within a new concourse container
concourse-shell: .certs
	docker-compose run --rm --entrypoint bash -w /concourse-keys concourse-web

rancher: .certs
	docker-compose up -d rancher
	docker-compose run --rm docker bash ./scripts/init-rancher.sh

rancher-stop:
	docker-compose stop rancher

rancher-shell: .certs
	docker-compose run --rm --entrypoint bash -w /etc/ssl/certs rancher

# Run this once to create "local" k8s cluster using rancher agent
# May need to reset local docker VM if there are etcd errors
k8s:
	docker-compose run --rm docker bash ./scripts/create-k8s-cluster.sh

up: portainer concourse rancher

down:
	docker-compose down --remove-orphans

# Bring down all components, delete all generated volumes
reset:
	echo Removing all containers, volumes and certificates
	docker-compose down --remove-orphans -v
	rm .docker .certs
