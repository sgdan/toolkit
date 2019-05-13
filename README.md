# Toolkit for container development

Use the 3 Musketeers pattern to run some tools for local container development

- [3 Musketeers](https://3musketeers.io) Pattern
- [Concourse CI](https://concourse-ci.org/)
- [Portainer](https://www.portainer.io/)

## How to run

- Update local `/etc/hosts` file with `127.0.0.1 dockerlocal`
- Install Docker Desktop and Make (e.g. with GitBash on Windows)
- Run `make portainer`
- Access Portainer on [https://dockerlocal:9000](https://dockerlocal:9000)
- Run `make concourse` which will generate keys and start the concourse db, web and worker components
- Access Concourse UI on [https://dockerlocal:8443](https://dockerlocal:8443)
