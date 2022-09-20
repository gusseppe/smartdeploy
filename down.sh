#!/bin/bash

if [[ $1 == "server" ]]; then
        compose_file="docker-compose-server.yml"
        printf "Welcome to SmartDeploy server\n"
        printf "\n\n"
    else
        compose_file="docker-compose-local.yml"
        printf "Welcome to SmartDeploy local\n"
        printf "\n\n"
fi

printf "Shutting down the components...\n"
printf "\n"

docker-compose  -f ${compose_file} down
