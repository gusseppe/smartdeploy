# SmartDeploy
MLOps ecosystem to develop and deploy ML models.


# Installation
For the first time, execute the folowing steps:

## Linux

- Install Docker and Docker compose
- Run `./install.sh`
- Then, only just `./run.sh`

## Windows

- Install Docker Desktop, then active Docker compose.
- Install WSL2 and link with Docker Desktop.

## Minimal mode

It deploys the minimal components to write pipelines.

- Run `./install.sh` (only run this once)
- Then, only just `./run.sh` (afterwards)

Note: If you need Neo4j or Ray, read the following modes.

## Neo4j mode

It deploys all the components plus Neo$j, it is meant for graph analysis.

- Perform the installation as mentioned above.
- Run `./install.sh neo` (only run this once)
- Then, only just `./run.sh neo` (afterwards)

## Server mode

It deploys all the components plus Ray Serve, it is meant for deployment scenarios.

- Perform the installation as mentioned above.
- Run `./install.sh neo` (only run this once)
- Then, only just `./run.sh neo` (afterwards)

# Shutdown 

- `./down.sh`
- `./down.sh server`
- `./down.sh neo`

