# SmartDeploy
MLOps ecosystem to develop and deploy ML models.


# Installation
For the first time, execute the folowing steps:

## Linux

- Install Docker and Docker compose
- Run ./install.sh
- Then, only just ./run.sh
## Windows

- Install Docker Desktop, then active Docker compose.
- Install WSL2 and link with Docker Desktop.
- Run ./install.sh
- Then, only just ./run.sh

## Server mode

It deploys all the components plus Ray Serve, it is meant for deployment scenarios.

- Perform the installation as mentioned above.
- Run ./install.sh server
- Then, only just ./run.sh server

# Shutdown 

- ./down.sh or ./down server

