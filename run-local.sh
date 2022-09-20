#!/bin/bash

printf "Welcome to SmartDeploy local\n"
printf "\n"

docker-compose  -f docker-compose-local.yml --env-file default.env up -d

BCyan='\033[1;36m'
NC='\033[0m' # No Color

printf "\n"
printf "[+] JupyterLab: \t ${BCyan}http://localhost:8888/lab${NC} token=jovyan\n"
printf "[+] Tracker [MLflow]:\t ${BCyan}http://localhost:5000 ${NC}\n"
printf "[+] Tracker [Minio]:\t ${BCyan}http://localhost:9000 ${NC}\n"
