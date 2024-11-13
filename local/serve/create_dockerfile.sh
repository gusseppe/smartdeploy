#!/bin/bash

# Set required environment variables
export MLFLOW_TRACKING_URI=http://localhost:5000
export MLFLOW_S3_ENDPOINT_URL=http://localhost:9000
export AWS_ACCESS_KEY_ID=minio
export AWS_SECRET_ACCESS_KEY=minio123

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

# Define the output directory for the Dockerfile
OUTPUT_DIR="mlflow-docker"

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Generate the Dockerfile
mlflow models generate-dockerfile -m "models:/${MODEL_NAME}/${MODEL_VERSION}" -d "$OUTPUT_DIR"

# Check if Dockerfile generation was successful
if [ $? -eq 0 ]; then
  echo "Dockerfile successfully generated in $OUTPUT_DIR"
else
  echo "Failed to generate Dockerfile."
  exit 1
fi
