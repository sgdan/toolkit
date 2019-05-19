#!/bin/bash

pass=$(grep PORTAINER_PASSWORD .env | cut -d "=" -f 2)
htpasswd -nbB admin $pass | cut -d ":" -f 2
