#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Variables
JENKINS_VERSION="13.4.25"
CHART_FILE="jenkins-$JENKINS_VERSION.tgz"
CONFIG_FILE="config-jenkins.yaml"
RELEASE_NAME="jenkins"
SERVICE_FILE="service.txt"
NODOS_FILE="nodos.txt"
FOLDER_PATH="/bitnami/jenkins/data"
PVC_FILE="jenkins-pvc.yaml"
JENKINS_VALUES_FILE="config-jenkins.yaml"

# Configurar variables de entorno para BOSH
export BOSH_CLIENT=ops_manager
export BOSH_CLIENT_SECRET=XEhkxJE82-xHwAmXu2gl_kYi1fYv355n
export BOSH_CA_CERT=/home/devops/Descargas/'root_ca_certificate(1)'
export BOSH_ENVIRONMENT=vcf-np-w2-bosh.sunat.peru
# export https_proxy=https://192.168.56.85:3128  # Descomentar si el proxy es necesario

# Obtener el servicio y los nodos
service=$(head -n 1 "$SERVICE_FILE")
mapfile -t servers < $NODOS_FILE

# Crear carpetas en los nodos para Jenkins usando BOSH
echo -e "${GREEN}Creando carpetas en los nodos para Jenkins...${NC}"
for server in "${servers[@]}"
do
  echo "Creando carpeta en: $server"
  bosh -d $service ssh $server "sudo mkdir -p $FOLDER_PATH && sudo chmod -R 777 $FOLDER_PATH"
  if [ $? -ne 0 ]; then
    echo "Error al crear carpeta en el nodo: $server. Continuando..."
  fi

  # Añadir configuración de proxy en cada nodo si es necesario
  bosh -d $service ssh $server "sudo echo 'export https_proxy=https://192.168.56.85:3128' >> .bashrc"
  bosh -d $service ssh $server ". .bashrc"
done

# Crear Volumen y PVC para Jenkins
echo -e "${GREEN}Creando Volumen y PVC para Jenkins...${NC}"
kubectl apply -f jenkins-volume.yaml
sleep 2
kubectl apply -f $PVC_FILE
sleep 2

# Instalar Jenkins usando Helm
echo -e "${GREEN}Instalando Jenkins usando Helm...${NC}"
helm upgrade --cleanup-on-fail --install $RELEASE_NAME ./$CHART_FILE --values $JENKINS_VALUES_FILE
if [ $? -ne 0 ]; then
  echo "Error al instalar Jenkins. Saliendo..."
  exit 1
fi
echo "Instalación de Jenkins iniciada."

# Esperar a que el Pod de Jenkins esté listo (1/1)
echo -e "${GREEN}Esperando a que el Pod de Jenkins esté listo...${NC}"
while true; do
  READY_STATUS=$(kubectl get pods -l app.kubernetes.io/name=jenkins -o jsonpath="{.items[0].status.containerStatuses[0].ready}")
  if [ "$READY_STATUS" == "true" ]; then
    echo "El Pod de Jenkins está listo."
    break
  else
    echo "Esperando a que el Pod de Jenkins esté listo..."
    sleep 5
  fi
done

# Obtener el NodePort para Jenkins
echo -e "${GREEN}Recuperando el NodePort para Jenkins...${NC}"
NODE_PORT=$(kubectl get svc $RELEASE_NAME -o=jsonpath='{.spec.ports[0].nodePort}')

if [ -z "$NODE_PORT" ]; then
  echo "Error al recuperar el NodePort. Saliendo..."
  exit 1
fi

echo -e "${GREEN}Jenkins está accesible en: http://localhost:$NODE_PORT${NC}"

