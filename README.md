# Toolkit for container development

Use the 3 Musketeers pattern to run some tools for local container development

- [3 Musketeers](https://3musketeers.io) Pattern
- [Concourse CI](https://concourse-ci.org/)
- [Portainer](https://www.portainer.io/)
- [Rancher 2](https://rancher.com/)

## Pre-requisites

- Update local `/etc/hosts` file with `127.0.0.1 dockerlocal`
- Install Docker Desktop and Make (e.g. with GitBash on Windows)

## Portainer

- Run `make portainer`
- Access Portainer on [https://dockerlocal:9000](https://dockerlocal:9000)

## Concourse

- Run `make concourse` which will generate keys and start the concourse db, web and worker components
- Access Concourse UI on [https://dockerlocal:8443](https://dockerlocal:8443)
  
## Rancher 2 & Kubernetes

- Run `make rancher`
- Access Rancher UI on [https://dockerlocal:9443](https://dockerlocal:9443)
- Optionally create local k8s cluster with `make k8s`
- Wait for the cluster to be initialised. I needed to reset my docker VM in order to avoid errors (etcd would not initialise properly).

## Hashicorp Vault for Credentials

- Run `make vault`
- Access Vault UI on [https://dockerlocal:8200](https://dockerlocal:8200)
