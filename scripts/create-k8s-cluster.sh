#!/bin/bash

# see https://gist.github.com/superseb/c363247c879e96c982495daea1125276 

RANCHER=https://dockerlocal:9443

# Get API token
LOGINTOKEN=$(curl -sk "$RANCHER/v3-public/localProviders/local?action=login" \
    --data-binary '{"username":"admin","password":"'${RANCHER_PASSWORD}'"}' \
    | jq -r .token)
APITOKEN=$(curl -sk "$RANCHER/v3/token" \
    -H "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '{"type":"token","description":"automation"}' \
    | jq -r .token)

# Create the cluster
CLUSTERID=$(curl -sk "$RANCHER/v3/cluster" \
    -H 'content-type: application/json' \
    -H "Authorization: Bearer $APITOKEN" \
    --data-binary '{"type":"cluster","name":"local","rancherKubernetesEngineConfig":{"type":"rancherKubernetesEngineConfig"}}' \
    | jq -r .id)

# Create registration token
curl -sk "$RANCHER/v3/clusterregistrationtoken" \
    -H 'content-type: application/json' \
    -H "Authorization: Bearer $APITOKEN" \
    --data-binary '{"type":"clusterRegistrationToken","clusterId":"'$CLUSTERID'"}' -o /dev/null

# Generate nodecommand (remove the sudo)
AGENTCMD=$(curl -sk "$RANCHER/v3/clusterregistrationtoken?id='$CLUSTERID'" \
    -H 'content-type: application/json' \
    -H "Authorization: Bearer $APITOKEN" \
    | jq -r '.data[].nodeCommand' | head -1 | cut -d ' ' -f2-)

# Run agent to create the node
$AGENTCMD --etcd --controlplane --worker
