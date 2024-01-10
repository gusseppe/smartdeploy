# SmartDeploy Local
MLOps ecosystem to develop and deploy ML models.

# Requirements
- Windows: WSL and Docker Desktop
- Linux: Docker and Docker-compose

# Installation

- The script `./install.sh full` downloads all the images and starts the containers.
- The script `./run.sh full` only starts the containers.
- The script `./down.sh full` shutdown the containers.

## Linux

- Install Docker and Docker compose
- Run `./install.sh full`
- Then, only just `./run.sh full`

## Windows

- Install Docker Desktop, then active Docker compose.
- Install WSL2 and link with Docker Desktop.

# Usage

Check the terminal's output for the urls:

[+] JupyterLab:          http://localhost:8889/lab token=jovyan

[+] Tracker [MLflow]:    http://localhost:5000

[+] Tracker [Minio]:     http://localhost:9000

[+] Ray Dashboard :      http://localhost:8265

# Shutdown 

- `./down.sh full`

# Other options

- You can check the other docker-compose file for other flavours.

