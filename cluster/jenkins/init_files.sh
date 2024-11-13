#!/bin/bash

# Variables
JENKINS_VERSION="13.4.25"
PVC_FILE="jenkins-pvc.yaml"
CONFIG_FILE="config-jenkins.yaml"
CHART_FILE="jenkins-$JENKINS_VERSION.tgz"
CHART_REPO="bitnami/jenkins"

# Step 1: Download Jenkins Helm chart
echo "Step 1: Downloading Jenkins Helm chart version $JENKINS_VERSION..."
helm pull $CHART_REPO --version $JENKINS_VERSION
if [ $? -ne 0 ]; then
  echo "Failed to download Helm chart. Exiting..."
  exit 1
fi
echo "Jenkins Helm chart downloaded: $CHART_FILE"

# Step 2: Create Persistent Volume Claim (PVC)
echo "Step 2: Creating Persistent Volume Claim (PVC) for Jenkins..."

cat <<EOF > $PVC_FILE
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF

kubectl apply -f $PVC_FILE
if [ $? -ne 0 ]; then
  echo "Failed to create PVC. Exiting..."
  exit 1
fi
echo "PVC created successfully."

# Step 3: Generate default config-jenkins.yaml
echo "Step 3: Generating default Jenkins configuration..."
helm show values $CHART_REPO --version $JENKINS_VERSION > $CONFIG_FILE
if [ $? -ne 0 ]; then
  echo "Failed to generate default config-jenkins.yaml. Exiting..."
  exit 1
fi
echo "Generated default Jenkins configuration: $CONFIG_FILE"

