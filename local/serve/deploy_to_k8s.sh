#!/bin/bash

# Define the YAML files
DEPLOYMENT_YAML="model-deployment.yaml"
SERVICE_YAML="model-service.yaml"

# Check if the deployment YAML file exists
if [ ! -f "$DEPLOYMENT_YAML" ]; then
  echo "Archivo de despliegue $DEPLOYMENT_YAML no encontrado!"
  exit 1
fi

# Check if the service YAML file exists
if [ ! -f "$SERVICE_YAML" ]; then
  echo "Archivo de servicio $SERVICE_YAML no encontrado!"
  exit 1
fi

# Apply the deployment YAML
echo "Aplicando $DEPLOYMENT_YAML en Kubernetes..."
kubectl apply -f "$DEPLOYMENT_YAML"
if [ $? -ne 0 ]; then
  echo "Error al aplicar $DEPLOYMENT_YAML."
  exit 1
fi

# Apply the service YAML
echo "Aplicando $SERVICE_YAML en Kubernetes..."
kubectl apply -f "$SERVICE_YAML"
if [ $? -ne 0 ]; then
  echo "Error al aplicar $SERVICE_YAML."
  exit 1
fi

echo "Despliegue y servicio aplicados con éxito en Kubernetes."

