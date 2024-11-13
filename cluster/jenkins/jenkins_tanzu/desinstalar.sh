#!/bin/bash

# Variables
PVC_FILE="jenkins-pvc.yaml"
RELEASE_NAME="jenkins"
PVC_NAME="jenkins-pvc"

# Función para eliminar un recurso de Kubernetes
safe_delete() {
  RESOURCE_TYPE=$1
  RESOURCE_NAME=$2

  if kubectl get $RESOURCE_TYPE $RESOURCE_NAME > /dev/null 2>&1; then
    echo "Eliminando $RESOURCE_TYPE: $RESOURCE_NAME"
    kubectl delete $RESOURCE_TYPE $RESOURCE_NAME
    if [ $? -ne 0 ]; then
      echo "Fallo al eliminar $RESOURCE_TYPE: $RESOURCE_NAME. Continuando..."
    else
      echo "$RESOURCE_TYPE: $RESOURCE_NAME eliminado con éxito."
    fi
  else
    echo "$RESOURCE_TYPE: $RESOURCE_NAME no encontrado. Saltando..."
  fi
}

# Paso 1: Desinstalar Jenkins usando Helm
echo "Desinstalando Jenkins usando Helm..."
helm uninstall $RELEASE_NAME || { echo "Fallo al desinstalar Jenkins."; exit 1; }

# Paso 2: Eliminar el PVC de Jenkins
echo "Eliminando el Persistent Volume Claim (PVC)..."
if kubectl get pvc $PVC_NAME > /dev/null 2>&1; then
  kubectl delete -f $PVC_FILE || { echo "Fallo al eliminar el PVC."; exit 1; }
else
  echo "PVC: $PVC_NAME no encontrado. Saltando."
fi

# Paso 3: Limpiar otros recursos de Kubernetes relacionados con Jenkins
echo "Limpiando otros recursos relacionados con Jenkins..."
safe_delete svc $RELEASE_NAME
safe_delete deploy $RELEASE_NAME
safe_delete configmap $RELEASE_NAME
safe_delete secret $RELEASE_NAME

echo "Limpieza completa."
