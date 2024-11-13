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

# Configurar variables de entorno BOSH
export BOSH_CLIENT=ops_manager
export BOSH_CLIENT_SECRET=XEhkxJE82-xHwAmXu2gl_kYi1fYv355n
export BOSH_CA_CERT=/home/devops/Descargas/'root_ca_certificate(1)'
export BOSH_ENVIRONMENT=vcf-np-w2-bosh.sunat.peru

# Verificar que el servicio y nodos existen
if [ ! -f "$SERVICE_FILE" ]; then
    echo "El archivo $SERVICE_FILE no se encontró."
    exit 1
fi

if [ ! -f "$NODOS_FILE" ]; then
    echo "El archivo $NODOS_FILE no se encontró."
    exit 1
fi

# Obtener el servicio y nodos
service=$(head -n 1 "$SERVICE_FILE")
mapfile -t servers < $NODOS_FILE

# Crear carpetas en los nodos usando BOSH
echo -e "${GREEN}Creando carpetas en los nodos para Jenkins...${NC}"
for server in "${servers[@]}"
do
  echo "Creando carpeta en: $server"
  bosh -d $service ssh $server "sudo mkdir -p $FOLDER_PATH && sudo chmod -R 777 $FOLDER_PATH"
  if [ $? -ne 0 ]; then
    echo "Error al crear carpeta en el nodo: $server. Continuando..."
  fi

  bosh -d $service ssh $server "sudo echo 'export https_proxy=https://192.168.56.85:3128' >> .bashrc"
  bosh -d $service ssh $server ". .bashrc"
done

# Crear Volumen y PVC para Jenkins
echo -e "${GREEN}Creando Volumen y PVC para Jenkins...${NC}"
kubectl apply -f jenkins-volume.yaml || { echo "Fallo al crear el volumen."; exit 1; }
kubectl apply -f $PVC_FILE || { echo "Fallo al crear el PVC."; exit 1; }

# Instalar Jenkins usando Helm
echo -e "${GREEN}Instalando Jenkins usando Helm...${NC}"
helm upgrade --cleanup-on-fail --install $RELEASE_NAME ./$CHART_FILE --values $JENKINS_VALUES_FILE || { echo "Fallo al instalar Jenkins."; exit 1; }

# Esperar a que el Pod de Jenkins esté listo
echo -e "${GREEN}Esperando a que el Pod de Jenkins esté listo...${NC}"
kubectl rollout status deployment/$RELEASE_NAME --timeout=300s || { echo "El pod de Jenkins no está listo."; exit 1; }

# Obtener la IP del LoadBalancer para Jenkins
echo -e "${GREEN}Recuperando la IP del LoadBalancer para Jenkins...${NC}"
while true; do
  EXTERNAL_IP=$(kubectl get svc $RELEASE_NAME -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [ -z "$EXTERNAL_IP" ]; then
    echo "Esperando a que la IP del LoadBalancer esté disponible..."
    sleep 5
  else
    echo "La IP del LoadBalancer es: $EXTERNAL_IP"
    break
  fi
done

echo -e "${GREEN}Jenkins está accesible en: http://$EXTERNAL_IP:8080${NC}"
