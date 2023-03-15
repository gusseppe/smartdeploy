# SmartDeploy
MLOps ecosystem to develop and deploy ML models.


# Installation

- The script `./install.sh` downloads all the images and starts the containers.
- The script `./run.sh` only starts the containers.
- The script `./down.sh` shutdown the containers.

## Linux

- Install Docker and Docker compose
- Run `./install.sh`
- Then, only just `./run.sh`

## Windows

- Install Docker Desktop, then active Docker compose.
- Install WSL2 and link with Docker Desktop.

## Minimal mode

It deploys the minimal components to write pipelines.

- Run `./install.sh minimal` (only run this once)
- Then, only just `./run.sh minimal` (afterwards)

## Minimal + Pyspark mode

It deploys the minimal components to write pipelines.

- Run `./install.sh pyspark` (only run this once)
- Then, only just `./run.sh pyspark` (afterwards)

## Neo4j mode

It deploys the minimal components plus Neo4j, it is meant for graph analysis.

- Perform the installation as mentioned above.
- Run `./install.sh neo` (only run this once)
- Then, only just `./run.sh neo` (afterwards)

## Server mode + jenkins

It deploys the minimal components plus Ray Serve, it is meant for deployment scenarios.

- Perform the installation as mentioned above.
- Run `./install.sh server` (only run this once)
- Then, only just `./run.sh server` (afterwards)

# Shutdown 

- `./down.sh`
- `./down.sh server`
- `./down.sh neo`

