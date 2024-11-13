#!/bin/bash

# Define the configuration file
CONFIG_FILE="config"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file $CONFIG_FILE not found!"
  exit 1
fi

# Read MODEL_NAME and MODEL_VERSION from the config file
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$CONFIG_FILE" | cut -d '=' -f 2)

# Check if MODEL_NAME and MODEL_VERSION are set
if [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ]; then
  echo "MODEL_NAME or MODEL_VERSION is not set in the configuration file."
  exit 1
fi

# Define the ZIP file name
ZIP_FILE="${MODEL_NAME}_${MODEL_VERSION}.zip"

# Files and folders to include in the ZIP (excluding create_deploy_file.sh)
FILES_TO_ZIP=("mlflow-docker" "deploy" "config" "build_docker_image.sh" "create_k8s_yaml.sh" "deploy_to_k8s.sh" "remove_from_k8s.sh" "send_request_to_pod.sh" "docker_push_image.sh" "end_to_end_cluster.sh" "README_CLUSTER.md")

# Zip the specified files and folders
echo "Creating ZIP file $ZIP_FILE..."
zip -r "$ZIP_FILE" "${FILES_TO_ZIP[@]}"

# Check if the ZIP operation was successful
if [ $? -eq 0 ]; then
  echo "ZIP file $ZIP_FILE created successfully."
else
  echo "Failed to create ZIP file."
  exit 1
fi
