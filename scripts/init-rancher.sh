#!/bin/sh

# see https://gist.github.com/superseb/c363247c879e96c982495daea1125276 

RANCHER=https://dockerlocal:9443

# Wait for Rancher to start
while ! curl -sk -o /dev/null $RANCHER/ping; do sleep 3; done

# Change admin password
LOGINRESPONSE=$(curl -sk "$RANCHER/v3-public/localProviders/local?action=login" \
    --data-binary '{"username":"admin","password":"admin"}')
LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token)
curl -sk "$RANCHER/v3/users?action=changepassword" \
    -H "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '{"currentPassword":"admin","newPassword":"'$RANCHER_PASSWORD'"}'
echo Admin password changed

# Set server url
APIRESPONSE=$(curl -sk "$RANCHER/v3/token" \
    -H "Authorization: Bearer $LOGINTOKEN" \
    --data-binary '{"type":"token","description":"automation"}')
APITOKEN=`echo $APIRESPONSE | jq -r .token`
curl -sk "$RANCHER/v3/settings/server-url" \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $APITOKEN" \
    -X PUT --data-binary '{"name":"server-url","value":"'$RANCHER'"}' -o /dev/null
echo Rancher url set to $RANCHER
