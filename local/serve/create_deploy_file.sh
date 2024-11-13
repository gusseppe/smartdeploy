#!/bin/bash

# Define the configuration file
CONFIG_FILE="config"
DEPLOY_FILE="deploy"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Archivo de configuración $CONFIG_FILE no encontrado!"
  exit 1
fi

# Leer MODEL_NAME y MODEL_VERSION del archivo de configuración
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$CONFIG_FILE" | cut -d '=' -f 2)

# Verificar si los valores están configurados
if [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ]; then
  echo "MODEL_NAME o MODEL_VERSION no están configurados en el archivo de configuración."
  exit 1
fi

# Valores predeterminados
DOCKER_REGISTRY="NOMBRE_DOCKER_REGISTRY"
TAG="latest"

# Crear el archivo de despliegue
echo "Creando archivo de despliegue $DEPLOY_FILE..."
echo "DOCKER_REGISTRY=$DOCKER_REGISTRY" > $DEPLOY_FILE
echo "MODEL_NAME=$MODEL_NAME" >> $DEPLOY_FILE
echo "MODEL_VERSION=$MODEL_VERSION" >> $DEPLOY_FILE
echo "TAG=$TAG" >> $DEPLOY_FILE

echo "Archivo de despliegue creado con éxito:"
cat $DEPLOY_FILE

