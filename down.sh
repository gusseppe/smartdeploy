#!/bin/bash

if [[ $1 == "server" ]]; then
    compose_file="docker-compose-server.yml"
    printf "Welcome to SmartDeploy server\n"
    printf "\n\n"
elif [[ $1 == "neo" ]]; then
    compose_file="docker-compose-local-neo4j.yml"
    printf "Welcome to SmartDeploy local + Neo4j\n"
    printf "\n\n"
elif [[ $1 == "minimal" ]]; then
    compose_file="docker-compose-local-minimal.yml"
    printf "Welcome to SmartDeploy local minimal\n"
    printf "\n\n"
elif [[ $1 == "pyspark" ]]; then
    compose_file="docker-compose-local-pyspark.yml"
    printf "Welcome to SmartDeploy local pyspark\n"
    printf "\n\n"
else
    compose_file="docker-compose-local.yml"
    printf "Welcome to SmartDeploy local\n"
    printf "\n\n"
fi

printf "Shutting down the components...\n"
printf "\n"

docker-compose  -f ${compose_file} down
