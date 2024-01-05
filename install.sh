#!/bin/bash

if [[ $1 == "server" ]]; then
    compose_file="docker-compose-server.yml"
    printf "\e[1mWelcome to SmartDeploy server\e[0m\n\n"
elif [[ $1 == "neo" ]]; then
    compose_file="docker-compose-local-neo4j.yml"
    printf "\e[1mWelcome to SmartDeploy local + Neo4j\e[0m\n\n"
elif [[ $1 == "minimal" ]]; then
    compose_file="docker-compose-local-minimal.yml"
    printf "\e[1mWelcome to SmartDeploy local minimal\e[0m\n\n"
elif [[ $1 == "pyspark" ]]; then
    compose_file="docker-compose-local-pyspark.yml"
    printf "\e[1mWelcome to SmartDeploy local pyspark\e[0m\n\n"
elif [[ $1 == "full" ]]; then
    compose_file="docker-compose-full.yml"
    printf "\e[1mWelcome to SmartDeploy full version\e[0m\n\n"
else
    compose_file="docker-compose-local.yml"
    printf "\e[1mWelcome to SmartDeploy local\e[0m\n\n"
fi

printf "\e[1mStarting the components...\e[0m\n\n"

docker-compose  -f ${compose_file} --env-file default.env up -d --build

BCyan='\033[1;36m'
NC='\033[0m' # No Color

printf "\n"
printf "[+] JupyterLab: \t ${BCyan}http://localhost:8889/lab${NC} token=jovyan\n"
printf "[+] Tracker [MLflow]:\t ${BCyan}http://localhost:5000 ${NC}\n"
printf "[+] Tracker [Minio]:\t ${BCyan}http://localhost:9000 ${NC}\n"

if [[ $1 == "full" ]]; then
    printf "[+] Ray Dashboard :\t ${BCyan}http://localhost:8265 ${NC}\n"
fi

if [[ $1 == "server" ]]; then
    printf "[+] Ray Dashboard :\t ${BCyan}http://localhost:8265 ${NC}\n"
    echo "Waiting for Jenkins service to start up..."
    sleep 3
    printf "[+] Jenkins Dashboard :\t ${BCyan}http://localhost:8084 ${NC}\n"
    PASSWORD=$(docker-compose -f docker-compose-server.yml logs --no-color jenkins 2>&1 | grep 'Please use the following password' -A 2 | tail -n 1 | tr -d '\r' | awk '{print $3}')
    printf "[+] Jenkins Initial Password :\t ${BCyan} ${PASSWORD} ${NC}\n"

fi
if [[ $1 == "neo" ]]; then
    printf "[+] Neo4j Dashboard :\t ${BCyan}http://localhost:7474 ${NC}\n"
fi
