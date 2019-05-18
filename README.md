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
  
## Rancher 2 & kubernetes

- Enable local kubernetes cluster in Docker preferences (may take a while to start)
- From Docker context menu choose the "docker-for-desktop" context (sets `~/.kube/config`)
- Run `make rancher`
- Access Rancher UI on [https://dockerlocal:9443](https://dockerlocal:9443)
- Add Cluster > Custom "From my own existing nodes"
- Choose etcd + Control Plane + Worker for local single node
- Copy and run the command. For windows gitbash remove `sudo` and double `/` for the volume mounts:

  ```sh
  docker run -d --privileged --restart=unless-stopped --net=host -v //etc/kubernetes:/etc/kubernetes -v //var/run:/var/run rancher/rancher-agent:v2.2.3 --server https://dockerlocal:9443 --token ... --ca-checksum ... --etcd --controlplane --worker
  ```

- Wait for the cluster to be initialised. I needed to reset my docker VM in order to avoid errors (etcd would not initialise properly).
