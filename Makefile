DOCKER = docker-compose run --rm docker

.env:
	$(DOCKER) cp env.example .env

# Utility shell with access to project folder
shell:
	$(DOCKER)

# Generate certs and keys for portainer and concourse
.certs: .env
	$(DOCKER) ./scripts/generate-certs.sh
	touch .certs

portainer: .certs
	ENCRYPTED_PASSWORD=$$($(DOCKER) ./scripts/encrypt-admin-pass.sh) \
	docker-compose up -d portainer

portainer-stop:
	docker-compose stop portainer

.concoursecerts: .env
	docker-compose run --rm concourse-shell ./scripts/concourse-certs.sh
	touch .concoursecerts

concourse: .certs .concoursecerts
	docker-compose up -d concourse-db concourse-web concourse-worker

concourse-stop:
	docker-compose stop concourse-db concourse-web concourse-worker

# start a bash shell within a new concourse container
concourse-shell: .certs
	docker-compose run --rm concourse-shell

rancher: .certs
	docker-compose up -d rancher
	$(DOCKER) ./scripts/init-rancher.sh

rancher-stop:
	docker-compose stop rancher

rancher-shell: .certs
	docker-compose run --rm --entrypoint bash -w /etc/ssl/certs rancher

# Run this once to create "local" k8s cluster using rancher agent
# May need to reset local docker VM if there are etcd errors
k8s:
	$(DOCKER) ./scripts/create-k8s-cluster.sh

.vault: vault/Dockerfile vault/config.json
	docker-compose build vault

vault: .vault .certs
	docker-compose up -d vault

vault-stop:
	docker-compose stop vault

vault-shell:
	docker-compose exec vault sh

up: portainer concourse rancher vault

down:
	docker-compose down --remove-orphans

# Bring down all components, delete all generated volumes
reset:
	echo Removing all containers, volumes and certificates
	docker-compose down --remove-orphans -v
	rm .certs .concoursecerts
