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

# Delete the deployment
echo "Eliminando el despliegue en Kubernetes..."
kubectl delete -f "$DEPLOYMENT_YAML"
if [ $? -ne 0 ]; then
  echo "Error al eliminar el despliegue."
  exit 1
fi

# Delete the service
echo "Eliminando el servicio en Kubernetes..."
kubectl delete -f "$SERVICE_YAML"
if [ $? -ne 0 ]; then
  echo "Error al eliminar el servicio."
  exit 1
fi

echo "Despliegue y servicio eliminados con éxito de Kubernetes."

