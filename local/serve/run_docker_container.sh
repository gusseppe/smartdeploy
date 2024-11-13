#!/bin/bash

# Set the port for accessing the model container
PORT=5001

# Define the configuration file
CONFIG_FILE="config"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file $CONFIG_FILE not found!"
  exit 1
fi

# Read MODEL_NAME and MODEL_VERSION directly from the file
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$CONFIG_FILE" | cut -d '=' -f 2)

# Check if the variables are set
if [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ]; then
  echo "MODEL_NAME or MODEL_VERSION is not set in the configuration file."
  exit 1
fi

# Define the Docker image name
IMAGE_NAME="${MODEL_NAME}_${MODEL_VERSION}"

# Run the Docker container
docker run -d -p "$PORT":8080 --name "${MODEL_NAME}_container" "$IMAGE_NAME"

# Check if the container started successfully
if [ $? -eq 0 ]; then
  echo "Docker container '${MODEL_NAME}_container' is running and accessible at http://localhost:$PORT"
else
  echo "Failed to start Docker container."
  exit 1
fi
