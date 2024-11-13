#!/bin/bash

# Variables
PVC_FILE="jenkins-pvc.yaml"
RELEASE_NAME="jenkins"
PVC_NAME="jenkins-pvc"

# Function to safely delete a Kubernetes resource
safe_delete() {
  RESOURCE_TYPE=$1
  RESOURCE_NAME=$2

  if kubectl get $RESOURCE_TYPE $RESOURCE_NAME > /dev/null 2>&1; then
    echo "Deleting $RESOURCE_TYPE: $RESOURCE_NAME"
    kubectl delete $RESOURCE_TYPE $RESOURCE_NAME
    if [ $? -ne 0 ]; then
      echo "Failed to delete $RESOURCE_TYPE: $RESOURCE_NAME. Continuing..."
    else
      echo "$RESOURCE_TYPE: $RESOURCE_NAME deleted successfully."
    fi
  else
    echo "$RESOURCE_TYPE: $RESOURCE_NAME not found. Skipping."
  fi
}

# Step 1: Uninstall Jenkins using Helm
echo "Step 1: Uninstalling Jenkins using Helm..."
helm uninstall $RELEASE_NAME
if [ $? -ne 0 ]; then
  echo "Failed to uninstall Jenkins. Exiting..."
  exit 1
fi
echo "Jenkins has been uninstalled."

# Step 2: Remove Jenkins PVC
echo "Step 2: Removing Persistent Volume Claim (PVC)..."
if kubectl get pvc $PVC_NAME > /dev/null 2>&1; then
  kubectl delete -f $PVC_FILE
  if [ $? -ne 0 ]; then
    echo "Failed to remove PVC. Continuing..."
  else
    echo "Persistent Volume Claim removed."
  fi
else
  echo "PVC: $PVC_NAME not found. Skipping."
fi

# Step 3: Clean up any remaining Kubernetes resources related to Jenkins
echo "Step 3: Cleaning up remaining Jenkins resources (if any)..."
safe_delete svc $RELEASE_NAME
safe_delete deploy $RELEASE_NAME
safe_delete configmap $RELEASE_NAME
safe_delete secret $RELEASE_NAME

echo "Cleanup completed."

