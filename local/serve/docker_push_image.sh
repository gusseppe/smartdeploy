#!/bin/bash

# Define the deploy file
DEPLOY_FILE="deploy"

# Check if the deploy file exists
if [ ! -f "$DEPLOY_FILE" ]; then
  echo "Archivo de despliegue $DEPLOY_FILE no encontrado!"
  exit 1
fi

# Read DOCKER_REGISTRY, MODEL_NAME, MODEL_VERSION, and TAG from the deploy file
DOCKER_REGISTRY=$(grep -w "DOCKER_REGISTRY" "$DEPLOY_FILE" | cut -d '=' -f 2)
MODEL_NAME=$(grep -w "MODEL_NAME" "$DEPLOY_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$DEPLOY_FILE" | cut -d '=' -f 2)
TAG=$(grep -w "TAG" "$DEPLOY_FILE" | cut -d '=' -f 2)

# Check if the values are set
if [ -z "$DOCKER_REGISTRY" ] || [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ] || [ -z "$TAG" ]; then
  echo "Algunos valores faltan en el archivo de despliegue."
  exit 1
fi

# Construct the full Docker image name
IMAGE_NAME="${MODEL_NAME}_${MODEL_VERSION}"
FULL_IMAGE_NAME="${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}"

# Tag the image
echo "Tagging image ${IMAGE_NAME} as ${FULL_IMAGE_NAME}..."
docker tag "$IMAGE_NAME" "$FULL_IMAGE_NAME"
if [ $? -ne 0 ]; then
  echo "Error al etiquetar la imagen Docker."
  exit 1
fi

# Docker login
echo "Iniciando sesión en Docker..."
docker login
if [ $? -ne 0 ]; then
  echo "Error en el inicio de sesión de Docker."
  exit 1
fi

# Push the tagged image to the registry
echo "Pushing image ${FULL_IMAGE_NAME} to Docker registry..."
docker push "$FULL_IMAGE_NAME"
if [ $? -ne 0 ]; then
  echo "Error al subir la imagen Docker."
  exit 1
fi

echo "Imagen Docker subida con éxito al repositorio ${DOCKER_REGISTRY}."

