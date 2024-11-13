#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # Sin color

# Paso 1: Construir la imagen Docker
echo -e "${BLUE}Paso 1: Construyendo la imagen Docker...${NC}"
./build_docker_image.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al construir la imagen Docker.${NC}"
  exit 1
fi

# Paso 2: Etiquetar y subir la imagen Docker al repositorio
echo -e "${BLUE}Paso 2: Etiquetando y subiendo la imagen Docker al repositorio...${NC}"
./docker_push_image.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al etiquetar o subir la imagen Docker.${NC}"
  exit 1
fi

# Paso 3: Crear archivos YAML para el despliegue en Kubernetes
echo -e "${BLUE}Paso 3: Creando archivos YAML para el despliegue en Kubernetes...${NC}"
./create_k8s_yaml.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al crear los archivos YAML para Kubernetes.${NC}"
  exit 1
fi

# Paso 4: Desplegar en Kubernetes
echo -e "${BLUE}Paso 4: Desplegando en Kubernetes...${NC}"
./deploy_to_k8s.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al desplegar en Kubernetes.${NC}"
  exit 1
fi

# Esperar unos segundos para asegurar que el pod esté listo
echo -e "${BLUE}Esperando a que el despliegue se estabilice...${NC}"
sleep 10

# Paso 5: Enviar solicitud al pod en el clúster
echo -e "${BLUE}Paso 5: Enviando solicitud al modelo en el pod...${NC}"
./send_request_to_pod.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al enviar la solicitud al pod.${NC}"
  exit 1
fi

echo -e "${GREEN}Proceso end-to-end completado con éxito en el clúster.${NC}"

