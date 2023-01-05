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
else
    compose_file="docker-compose-local.yml"
    printf "Welcome to SmartDeploy local\n"
    printf "\n\n"
fi

printf "Building the components...\n"
printf "\n"

docker-compose  -f ${compose_file} --env-file default.env up -d --build

BCyan='\033[1;36m'
NC='\033[0m' # No Color

printf "\n"
printf "[+] JupyterLab: \t ${BCyan}http://localhost:8889/lab${NC} token=jovyan\n"
printf "[+] Tracker [MLflow]:\t ${BCyan}http://localhost:5000 ${NC}\n"
printf "[+] Tracker [Minio]:\t ${BCyan}http://localhost:9000 ${NC}\n"

if [[ $1 == "server" ]]; then
    printf "[+] Ray Dashboard :\t ${BCyan}http://localhost:8265 ${NC}\n"
fi
if [[ $1 == "neo" ]]; then
    printf "[+] Neo4j Dashboard :\t ${BCyan}http://localhost:7474 ${NC}\n"
fi
