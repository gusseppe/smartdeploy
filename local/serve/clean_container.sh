#!/bin/bash

# Define the configuration file
CONFIG_FILE="config"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file $CONFIG_FILE not found!"
  exit 1
fi

# Read MODEL_NAME from the config file
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)

# Check if MODEL_NAME is set
if [ -z "$MODEL_NAME" ]; then
  echo "MODEL_NAME is not set in the configuration file."
  exit 1
fi

# Define the container name
CONTAINER_NAME="${MODEL_NAME}_container"

# Stop the container
echo "Stopping container $CONTAINER_NAME..."
docker stop "$CONTAINER_NAME"

# Remove the container
echo "Removing container $CONTAINER_NAME..."
docker rm "$CONTAINER_NAME"

# Check if the operations were successful
if [ $? -eq 0 ]; then
  echo "Container $CONTAINER_NAME stopped and removed successfully."
else
  echo "Failed to stop or remove the container $CONTAINER_NAME."
  exit 1
fi

