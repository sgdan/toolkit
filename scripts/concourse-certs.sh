#!/bin/bash

# Generate keys for Concourse CI
cd /concourse-keys
EXE=/usr/local/concourse/bin/concourse
[ ! -f session_siging_key ] && $EXE generate-key -t rsa -f ./session_signing_key
[ ! -f tsa_host_key ]       && $EXE generate-key -t ssh -f ./tsa_host_key
[ ! -f worker_key ]         && $EXE generate-key -t ssh -f ./worker_key
cp worker_key.pub authorized_worker_keys
