#!/bin/bash

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # Sin color

# Define the configuration file
CONFIG_FILE="config"

# Verificar si el archivo de configuración existe
if [ ! -f "$CONFIG_FILE" ]; then
  echo -e "${RED}Archivo de configuración $CONFIG_FILE no encontrado!${NC}"
  exit 1
fi

# Leer MODEL_NAME y MODEL_VERSION del archivo de configuración
MODEL_NAME=$(grep -w "MODEL_NAME" "$CONFIG_FILE" | cut -d '=' -f 2)
MODEL_VERSION=$(grep -w "MODEL_VERSION" "$CONFIG_FILE" | cut -d '=' -f 2)

# Verificar si los valores están configurados
if [ -z "$MODEL_NAME" ] || [ -z "$MODEL_VERSION" ]; then
  echo -e "${RED}MODEL_NAME o MODEL_VERSION no están configurados en el archivo de configuración.${NC}"
  exit 1
fi

# Paso 1: Crear Dockerfile
echo -e "${BLUE}Paso 1: Creando Dockerfile...${NC}"
./create_dockerfile.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al crear el Dockerfile.${NC}"
  exit 1
fi

# Paso 2: Construir la imagen Docker
echo -e "${BLUE}Paso 2: Construyendo la imagen Docker...${NC}"
./build_docker_image.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al construir la imagen Docker.${NC}"
  exit 1
fi

# Paso 3: Generar JSON de entrada
echo -e "${BLUE}Paso 3: Generando JSON de entrada...${NC}"
./generate_input_json.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al generar el JSON de entrada.${NC}"
  exit 1
fi

# Paso 4: Ejecutar el contenedor Docker
echo -e "${BLUE}Paso 4: Ejecutando el contenedor Docker...${NC}"
./run_docker_container.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al ejecutar el contenedor Docker.${NC}"
  exit 1
fi

# Esperar unos segundos para asegurar que el contenedor esté listo
sleep 5

# Paso 5: Enviar solicitud al modelo
echo -e "${BLUE}Paso 5: Enviando solicitud al modelo...${NC}"
./send_request.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al enviar la solicitud al modelo.${NC}"
  exit 1
fi

# Paso 6: Detener y limpiar el contenedor
echo -e "${BLUE}Paso 6: Deteniendo y limpiando el contenedor...${NC}"
./clean_container.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al detener o limpiar el contenedor.${NC}"
  exit 1
fi

# Paso 7: Crear el archivo de despliegue
echo -e "${BLUE}Paso 7: Creando archivo de despliegue...${NC}"
./create_deploy_file.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al crear el archivo de despliegue.${NC}"
  exit 1
fi

# Paso 8: Comprimir los archivos necesarios
echo -e "${BLUE}Paso 8: Comprimiendo archivos necesarios...${NC}"
./zip_files.sh
if [ $? -ne 0 ]; then
  echo -e "${RED}Error al comprimir los archivos.${NC}"
  exit 1
fi

echo -e "${GREEN}Proceso end-to-end completado con éxito.${NC}"

