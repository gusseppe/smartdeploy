#!/bin/bash

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

# Define the output directory where the Dockerfile is located
OUTPUT_DIR="mlflow-docker"

# Check if Dockerfile exists in the output directory
if [ ! -f "$OUTPUT_DIR/Dockerfile" ]; then
  echo "Dockerfile not found in $OUTPUT_DIR. Please generate it first."
  exit 1
fi

# Build the Docker image
IMAGE_NAME="${MODEL_NAME}_${MODEL_VERSION}"
docker build -t "$IMAGE_NAME" "$OUTPUT_DIR"

# Check if the image was built successfully
if [ $? -eq 0 ]; then
  echo "Docker image '$IMAGE_NAME' successfully built."
else
  echo "Failed to build Docker image."
  exit 1
fi
