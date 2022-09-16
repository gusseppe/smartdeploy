#!/bin/bash
printf "Welcome to SmartDeploy server\n"
printf "\n\n"

printf "Building the components...\n"
printf "\n"

docker-compose  --env-file default.env up -d --build

BCyan='\033[1;36m'
NC='\033[0m' # No Color

printf "\n"
printf "[+] JupyterLab: \t ${BCyan}http://localhost:8888/lab${NC} token=jovyan\n"
printf "[+] Tracker [MLflow]:\t ${BCyan}http://localhost:5000 ${NC}\n"
printf "[+] Tracker [Minio]:\t ${BCyan}http://localhost:9000 ${NC}\n"
printf "[+] Ray Dashboard :\t ${BCyan}http://localhost:8265 ${NC}\n"
