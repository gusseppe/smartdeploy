#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Crear carpetas en los nodos POSTGRESQL
folder_path="/bitnami/postgresql/data"
username="root"
service_file="service.txt"
nodos="nodos.txt"

service=$(head -n 1 "$service_file")

mapfile -t servers < $nodos
export BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=XEhkxJE82-xHwAmXu2gl_kYi1fYv355n BOSH_CA_CERT=/home/devops/Descargas/'root_ca_certificate(1)' BOSH_ENVIRONMENT=vcf-np-w2-bosh.sunat.peru
# export https_proxy=https://192.168.56.85:3128
for server in "${servers[@]}"
do
  echo "Creando carpeta en : $server"
  bosh -d $service ssh $server "sudo mkdir -p $folder_path && sudo chmod -R 777 $folder_path"
  bosh -d $service ssh $server "sudo echo 'export https_proxy=https://192.168.56.85:3128' >> .bashrc"
  bosh -d $service ssh $server ". .bashrc"
done

# Volumen y PVC para PostgreSQL
echo -e "${GREEN}Creando Volumen y PVC para PostgreSQL...${NC}"
kubectl apply -f pg-volume.yaml
sleep 2
kubectl apply -f pg-pvc.yaml
sleep 2

# Instalar chart de PostgreSQL
echo -e "${GREEN}Instalando chart de PostgreSQL...${NC}"
helm upgrade --cleanup-on-fail --install postgresql ./postgresql-11.9.11.tgz --values config-postgresql.yaml
sleep 10
echo -e "${YELLOW}Output de helm status postgresql:${NC}"
helm status postgresql


# Crear carpetas en los nodos JUPYTERHUB
folder_path="/bitnami/jupyterhub/data"
username="root"
mapfile -t servers < $nodos
for server in "${servers[@]}"
do
  echo "Creando carpeta en : $server"
  bosh -d $service ssh $server "sudo mkdir -p $folder_path && sudo chmod -R 777 $folder_path"
done

# Crear carpetas en los nodos JUPYTERHUB
folder_path="/bitnami/postgresql-jupyterhub/data"
username="root"
mapfile -t servers < $nodos
for server in "${servers[@]}"
do
  echo "Creando carpeta en : $server"
  bosh -d $service ssh $server "sudo mkdir -p $folder_path && sudo chmod -R 777 $folder_path"
done

# Volumen y PVC para Postgresql-Jupyterhub
echo "Creando Volumen y PVC para Postgresql-Jupyterhub..."
kubectl apply -f pg-jupyterhub-volume.yaml
sleep 2
kubectl apply -f pg-jupyterhub-pvc.yaml
sleep 2

# Instalar chart de Postgresql-Jupyterhub
echo -e "${GREEN}Instalando chart de PostgreSQL-Jupyterhub..${NC}"
helm upgrade --cleanup-on-fail --install postgresql-jupyterhub ./postgresql-11.9.11.tgz --values config-postgresql-jupyterhub.yaml
sleep 10
echo -e "${YELLOW}Output de helm status PostgreSQL-Jupyterhub:${NC}"
helm status postgresql-jupyterhub


# Volumen y PVC para Jupyterhub
echo "Creando Volumen y PVC para Jupyterhub..."
kubectl apply -f jupyterhub-volume.yaml
sleep 2
kubectl apply -f jupyterhub-pvc.yaml
sleep 2

# Instalar chart de Postgresql-Jupyterhub
echo -e "${GREEN}Instalando chart de Jupyterhub..${NC}"
helm upgrade --cleanup-on-fail --install jupyterhub ./jupyterhub-2.0.0.tgz --values config-jupyterhub.yaml
sleep 10
echo -e "${YELLOW}Output de helm status Jupyterhub:${NC}"
helm status jupyterhub

# Crear carpetas en los nodos MINIO
folder_path="/bitnami/minio/data"
username="root"
mapfile -t servers < $nodos
for server in "${servers[@]}"
do
  echo "Creando carpeta en : $server"
  bosh -d $service ssh $server "sudo mkdir -p $folder_path && sudo chmod -R 777 $folder_path"
done

# Volumen y PVC para Minio
echo "Creando Volumen y PVC para Minio..."
kubectl apply -f minio-volume.yaml
sleep 2
kubectl apply -f minio-pvc.yaml
sleep 2

# Instalar chart de Minio
echo "${GREEN}Instalando chart de Minio...${NC}"
helm upgrade --cleanup-on-fail --install minio ./minio-11.10.9.tgz --values config-minio.yaml
sleep 10
echo "Output de helm status Minio:"
helm status minio



# Instalar chart de MLflow
echo "${GREEN}Instalando chart de MLflow...${NC}"
helm  upgrade --cleanup-on-fail --install  mlflow ./mlflow-0.7.13.tgz --values config-mlflow.yaml
sleep 10
echo "Output de helm status MLflow:"
helm status mlflow

# Instalar chart de Ray
echo "${GREEN}Instalando chart de Ray...${NC}"
helm  upgrade --cleanup-on-fail --install kuberay-operator ./kuberay-operator-0.4.0.tgz --values config-ray-operator.yaml
sleep 5
helm   upgrade --cleanup-on-fail --install raycluster ./ray-cluster-0.4.0.tgz --values config-ray.yaml
sleep 10
echo "Output de helm status Ray cluster:"
helm status raycluster
